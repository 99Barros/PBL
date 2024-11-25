import dash
from dash import dcc, html
from dash.dependencies import Input, Output, State
import plotly.graph_objs as go
import requests
import sys
from datetime import datetime
import pytz
import subprocess

try:
    import pick
except ImportError:
    subprocess.check_call([sys.executable, "-m", "pip", "install", "pick"])

# Constants for IP and port
IP_ADDRESS = "4.228.58.99"
PORT_STH = 8666
DASH_HOST = "0.0.0.0"  # Set this to "0.0.0.0" to allow access from any IP

# Function to get luminosity data from the API
def get_data(attribute, lastN):
    url = f"http://{IP_ADDRESS}:{PORT_STH}/STH/v1/contextEntities/type/Lamp/id/urn:ngsi-ld:Lamp:05x/attributes/{attribute}?lastN={lastN}"
    headers = {
        'fiware-service': 'smart',
        'fiware-servicepath': '/'
    }
    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        data = response.json()
        try:
            values = data['contextResponses'][0]['contextElement']['attributes'][0]['values']
            return values
        except KeyError as e:
            print(f"Key error: {e}")
            return []
    else:
        print(f"Error accessing {url}: {response.status_code}")
        return []

# Function to convert UTC timestamps to Lisbon time
def convert_to_lisbon_time(timestamps):
    utc = pytz.utc
    lisbon = pytz.timezone('Europe/Lisbon')
    converted_timestamps = []
    for timestamp in timestamps:
        try:
            timestamp = timestamp.replace('T', ' ').replace('Z', '')
            converted_time = utc.localize(datetime.strptime(timestamp, '%Y-%m-%d %H:%M:%S.%f')).astimezone(lisbon)
        except ValueError:
            # Handle case where milliseconds are not present
            converted_time = utc.localize(datetime.strptime(timestamp, '%Y-%m-%d %H:%M:%S')).astimezone(lisbon)
        converted_timestamps.append(converted_time)
    return converted_timestamps

# Function to calculate error
def calculate_error(setpoint, process_value):
    return setpoint - process_value

# Function to calculate time constant
def calculate_time_constant(process_value, setpoint, time):
    lower_limit = 0.95 * setpoint
    upper_limit = 1.05 * setpoint

    if process_value >= lower_limit and process_value <= upper_limit:
        return time
    else:
        return None

# Set lastN value
lastN = 20  # Get 20 most recent points at each interval

# Dash application setup
app = dash.Dash(__name__)

# Variable to store user input for setpoint
user_setpoint = None

app.layout = html.Div([ 
    html.H1('Sensor Data Viewer'),
    dcc.Graph(id='temperature-graph'),
    html.Div([
        html.H4("Erro: "),
        html.Div(id='error-output', style={'font-size': '20px', 'color': 'blue'}),
    ]),
    html.Div([
        html.H4("Constante de Tempo: "),
        html.Div(id='time-constant-output', style={'font-size': '20px', 'color': 'green'}),
    ]),
    dcc.Store(id='sensor-data-store', data={'timestamps': [], 'temperature_values': []}),
    dcc.Store(id='setpoint-store', data={'sp': None}),  # Store to hold setpoint
    dcc.Interval(
        id='interval-component',
        interval=10*1000,  # in milliseconds (10 seconds)
        n_intervals=0
    )
])

# Inicialize uma variável para armazenar a constante de tempo determinada
time_constant_determined = None

@app.callback(
    [Output('sensor-data-store', 'data'),
     Output('error-output', 'children'),
     Output('time-constant-output', 'children')],
    Input('interval-component', 'n_intervals'),
    State('sensor-data-store', 'data')
)
def update_data_and_calculate(n, stored_data):
    global time_constant_determined  # Referência à variável global

    # Update sensor data
    data_temperature = get_data('temperature', lastN)
    setpoint = sp  # Setpoint fornecido pelo usuário
    time_constant = None

    if data_temperature:
        temperature_values = [float(entry['attrValue']) for entry in data_temperature]
        timestamps = [entry['recvTime'] for entry in data_temperature]

        timestamps = convert_to_lisbon_time(timestamps)

        # Update stored data with the most recent lastN points
        stored_data['timestamps'] = timestamps[-lastN:]
        stored_data['temperature_values'] = temperature_values[-lastN:]

        # Calculate error (last measured value relative to setpoint)
        if temperature_values:
            process_value = temperature_values[-1]
            error = calculate_error(setpoint, process_value)

            # Only calculate the time constant if it hasn't been determined yet
            if time_constant_determined is None:
                time_constant_determined = calculate_time_constant(process_value, setpoint, timestamps[-1])

        else:
            error = "Sem dados disponíveis"
    else:
        error = "Erro ao buscar dados do sensor"

    # Prepare time constant output
    time_constant_text = time_constant_determined if time_constant_determined is not None else "Fora da faixa"

    # Ensure the function returns the correct structure for the data and outputs
    return {'timestamps': stored_data['timestamps'], 'temperature_values': stored_data['temperature_values']}, f"{error:.2f} °C" if isinstance(error, (int, float)) else error, str(time_constant_text)

@app.callback(
    Output('temperature-graph', 'figure'),
    Input('sensor-data-store', 'data')
)
def update_temperature_graph(stored_data):
    fig_temperature = create_graph(
        stored_data, 'temperature_values', 'red', 'Temperature (°C)', y_min=12, y_max=25
    )
    return fig_temperature

def create_graph(trace_values, trace_name, color, y_title, y_min=None, y_max=None):
    fig = go.Figure(data=[go.Scatter(
        x=trace_values['timestamps'],
        y=trace_values[trace_name],
        mode='lines+markers',
        name=trace_name,
        line=dict(color=color)
    )])

    # Add limit traces with legends
    if y_min is not None:
        fig.add_trace(go.Scatter(
            x=trace_values['timestamps'],
            y=[y_min] * len(trace_values['timestamps']),
            mode='lines',
            line=dict(color='black', dash='dash'),
            name=f'{y_title} Min'
        ))

    if y_max is not None:
        fig.add_trace(go.Scatter(
            x=trace_values['timestamps'],
            y=[y_max] * len(trace_values['timestamps']),
            mode='lines',
            line=dict(color='black', dash='dash'),
            name=f'{y_title} Max'
        ))

    fig.update_layout(
        title=f'{trace_name.capitalize()} Over Time',
        xaxis_title='Timestamp',
        yaxis_title=y_title,
        hovermode='closest'
    )

    return fig

if __name__ == '__main__':
    name, index = pick.pick(options=['Malha Fechada', 'Malha Aberta'],
                            title="Selecione o tipo de malha de controle",
                            indicator='->',
                            clear_screen=True
                            )
    if name.upper() == "MALHA FECHADA":
        malha = "fechada"
        print("Foi selecionada a malha fechada")
        sp = float(input("Digite o valor do Set Point: "))
        kp = float(input("Digite o valor do KP: "))
        ki = float(input("Digite o valor do KI: "))
        kd = float(input("Digite o valor do KD: "))
        # Store the setpoint in the session state
        user_setpoint = sp
    elif name.upper() == "MALHA ABERTA":
        malha = "aberta"
        print("Foi selecionada a malha aberta")
        pwm = float(input("Digite o valor do PWM: "))

    # Set the setpoint in the store before starting the app
    app.layout['setpoint-store'].data = {'sp': user_setpoint} if user_setpoint is not None else {'sp': 20}

    app.run_server(host=DASH_HOST, port=8050)

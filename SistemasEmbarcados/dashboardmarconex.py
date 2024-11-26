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
LIMITE_INFERIOR = 0.95
LIMITE_SUPERIOR = 1.05

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

def calculate_gain(process_value, setpoint):
    return process_value / setpoint

# Function to calculate error
def calculate_error(setpoint, process_value):
    return setpoint - process_value

# Function to calculate time constant
def calculate_time_constant(process_value, setpoint, current_time, initial_time):
    lower_limit = LIMITE_INFERIOR * setpoint
    upper_limit = LIMITE_SUPERIOR * setpoint

    if lower_limit <= process_value <= upper_limit:
        time_constant = (current_time - initial_time).total_seconds()
        return time_constant
    else:
        return None

# Set lastN value
lastN = 20  # Get 20 most recent points at each interval

# Dash application setup
app = dash.Dash(__name__)

# Variable to store user input for setpoint and time
user_setpoint = None
initial_time = None

app.layout = html.Div([
    html.H1('Sensor Data Viewer'),
    # Dropdown to select the control loop type
    html.Div([
        html.H4("Selecione o tipo de malha de controle:"),
        dcc.Dropdown(
            id='loop-type-dropdown',
            options=[
                {'label': 'Malha Fechada', 'value': 'fechada'},
                {'label': 'Malha Aberta', 'value': 'aberta'}
            ],
            value='fechada',  # Default value
        ),
    ]),
    # Input for setpoint value
    html.Div([
        html.H4("Digite o valor do Setpoint (°C):"),
        dcc.Input(id='setpoint-input', type='number', value=20, step=0.1),  # Default setpoint value
    ]),
    # Input for initial time
    html.Div([
        html.H4("Digite a hora de início do aquecimento (HH:mm):"),
        dcc.Input(id='initial-time-input', type='text', value='00:00', debounce=True),  # Default time value
    ]),
    # Graph to display the temperature data
    dcc.Graph(id='temperature-graph'),
    html.Div([
        html.H4("Erro: "),
        html.Div(id='error-output', style={'font-size': '20px', 'color': 'blue'}),
    ]),
    html.Div([
        html.H4("Constante de Tempo: "),
        html.Div(id='time-constant-output', style={'font-size': '20px', 'color': 'green'}),
    ]),
    html.Div([
        html.H4("Ganho: "),
        html.Div(id='gain-output', style={'font-size': '20px', 'color': 'orange'}),
    ]),
    dcc.Store(id='sensor-data-store', data={'timestamps': [], 'temperature_values': []}),
    dcc.Store(id='setpoint-store', data={'sp': None}),
    dcc.Interval(
        id='interval-component',
        interval=10*1000,  # in milliseconds (10 seconds)
        n_intervals=0
    )
])

@app.callback(
    [Output('sensor-data-store', 'data'),
     Output('error-output', 'children'),
     Output('time-constant-output', 'children'),
     Output('gain-output', 'children')],
    [Input('interval-component', 'n_intervals'),
     Input('loop-type-dropdown', 'value'),
     Input('setpoint-input', 'value'),
     Input('initial-time-input', 'value'),
     State('sensor-data-store', 'data')]
)
def update_data_and_calculate(n, loop_type, setpoint, initial_time_input, stored_data):
    global initial_time  # Use the initial_time provided by the user

    # Atualizar dados do sensor
    data_temperature = get_data('temperature', lastN)
    user_setpoint = setpoint  # Usar o setpoint fornecido pelo usuário
    gain = None
    time_constant = None

    if data_temperature:
        temperature_values = [float(entry['attrValue']) for entry in data_temperature]
        timestamps = [entry['recvTime'] for entry in data_temperature]
        timestamps = convert_to_lisbon_time(timestamps)

        # Atualizar dados armazenados
        stored_data['timestamps'] = timestamps[-lastN:]
        stored_data['temperature_values'] = temperature_values[-lastN:]

        # Calcular o erro e o ganho
        if temperature_values:
            process_value = temperature_values[-1]
            error = calculate_error(user_setpoint, process_value)
            gain = calculate_gain(process_value, user_setpoint)

            # Calcular a constante de tempo apenas se ainda não foi determinada
            if time_constant is None and initial_time is not None:
                time_constant = calculate_time_constant(
                    process_value, user_setpoint, timestamps[-1], initial_time
                )
        else:
            error = "Sem dados disponíveis"
    else:
        error = "Erro ao buscar dados do sensor"

    # Processar o tempo inicial
    try:
        # A hora inserida pelo usuário é interpretada como sendo no formato HH:mm
        initial_time = datetime.strptime(initial_time_input, '%H:%M')
        
        # Definir o ano, mês e dia atuais para completar a data
        initial_time = initial_time.replace(year=datetime.now().year, month=datetime.now().month, day=datetime.now().day)

        # Convertendo diretamente para Lisboa, sem passar por UTC
        initial_time = pytz.timezone('Europe/Lisbon').localize(initial_time)
    except ValueError:
        initial_time = None

    # Preparar saída da constante de tempo
    time_constant_text = f"{time_constant:.2f} segundos" if time_constant is not None else "Fora da faixa"
    gain_text = f"{gain:.2f}" if gain is not None else "Indisponível"

    return {'timestamps': stored_data['timestamps'], 'temperature_values': stored_data['temperature_values']}, \
           f"{error:.2f} °C" if isinstance(error, (int, float)) else error, \
           time_constant_text, \
           gain_text

@app.callback(
    Output('temperature-graph', 'figure'),
    [Input('sensor-data-store', 'data'),
     State('setpoint-store', 'data')]
)
def update_temperature_graph(stored_data, setpoint_store):
    setpoint = setpoint_store.get('sp', 20)  # Valor padrão do setpoint
    fig_temperature = create_graph(
        stored_data, 'temperature_values', 'red', 'Temperature (°C)', setpoint=setpoint
    )
    return fig_temperature


def create_graph(trace_values, trace_name, color, y_title, setpoint=None):
    fig = go.Figure(data=[go.Scatter(
        x=trace_values['timestamps'],
        y=trace_values[trace_name],
        mode='lines+markers',
        name=trace_name,
        line=dict(color=color)
    )])

    if setpoint is not None:
        fig.add_trace(go.Scatter(
            x=trace_values['timestamps'],
            y=[setpoint] * len(trace_values['timestamps']),
            mode='lines',
            name='Setpoint',
            line=dict(color='blue', dash='dash')
        ))

    fig.update_layout(
        title=f"Sensor Data - {trace_name}",
        xaxis=dict(title='Time'),
        yaxis=dict(title=y_title),
        template='plotly_dark'
    )

    return fig


if __name__ == '__main__':
    app.run_server(debug=True, host=DASH_HOST, port=8050)

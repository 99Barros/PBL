import dash
from dash import dcc, html
from dash.dependencies import Input, Output, State
import plotly.graph_objs as go
import math
import numpy as np
from datetime import datetime
import pytz

# Constants for IP and port
IP_ADDRESS = "4.228.58.99"
PORT_STH = 8666
DASH_HOST = "0.0.0.0"  # Set this to "0.0.0.0" to allow access from any IP

# Function to simulate luminosity data as a sine wave
def generate_sine_wave_data(lastN):
    # Create an array of timestamps (for simplicity, use a range of numbers)
    current_time = datetime.now()
    timestamps = [current_time - timedelta(seconds=i * 10) for i in range(lastN)]  # 10s interval
    timestamps = [t.strftime('%Y-%m-%d %H:%M:%S') for t in timestamps]
    
    # Generate a sine wave for temperature between 10 and 30
    # Use numpy to create sine wave data for temperature
    time_points = np.linspace(0, 2 * np.pi, lastN)  # Generate N points for sine wave
    temperature_values = 20 + 5 * np.sin(time_points)  # Base of 20°C with amplitude of 5°C
    
    return timestamps, temperature_values

# Function to convert UTC timestamps to Lisbon time
def convert_to_lisbon_time(timestamps):
    utc = pytz.utc
    lisbon = pytz.timezone('Europe/Lisbon')
    converted_timestamps = []
    for timestamp in timestamps:
        try:
            timestamp = timestamp.replace('T', ' ').replace('Z', '')
            converted_time = utc.localize(datetime.strptime(timestamp, '%Y-%m-%d %H:%M:%S')).astimezone(lisbon)
        except ValueError:
            # Handle case where milliseconds are not present
            converted_time = utc.localize(datetime.strptime(timestamp, '%Y-%m-%d %H:%M:%S')).astimezone(lisbon)
        converted_timestamps.append(converted_time)
    return converted_timestamps

# Set lastN value
lastN = 20  # Get 10 most recent points at each interval

app = dash.Dash(__name__)

app.layout = html.Div([
    html.H1('Sensor Data Viewer'),
    dcc.Graph(id='temperature-graph'),
    dcc.Store(id='sensor-data-store', data={'timestamps': [], 'temperature_values': []}),
    dcc.Interval(
        id='interval-component',
        interval=10*1000,  # in milliseconds (10 seconds)
        n_intervals=0
    )
])

@app.callback(
    Output('sensor-data-store', 'data'),
    Input('interval-component', 'n_intervals'),
    State('sensor-data-store', 'data')
)
def update_data_store(n, stored_data):
    # Simulate Sensor Data with a sine wave
    timestamps, temperature_values = generate_sine_wave_data(lastN)

    # Convert timestamps to Lisbon time
    timestamps = convert_to_lisbon_time(timestamps)

    # Update the stored data with the new values
    stored_data['timestamps'] = timestamps[-lastN:]
    stored_data['temperature_values'] = temperature_values[-lastN:]

    return stored_data

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

@app.callback(
    Output('temperature-graph', 'figure'),
    Input('sensor-data-store', 'data')
)
def update_temperature_graph(stored_data):
    fig_temperature = create_graph(
        stored_data, 'temperature_values', 'red', 'Temperature (°C)', y_min=12, y_max=25
    )
    return fig_temperature

if __name__ == '__main__':
    app.run_server(debug=True, host=DASH_HOST, port=8050)

#Script created using Github Copilot


import json
import os

import matplotlib.pyplot as plt


VARIABLES = {
    "client": "Client",
    "packet_loss": "packet_loss",
    "ping": "ping",
    "time": "time"
}


def extract_data_from_json(directory):
    # Initialize data structure
    data = {}
    for filename in os.listdir(directory):
        if filename.endswith(".json"):
            filepath = os.path.join(directory, filename)
            client_name = filename.replace("network_data_", "").replace(".json", "")  # Extract client name from filename
            if client_name not in data:
                data[client_name] = {key: [] for key in VARIABLES.keys()}
            with open(filepath, 'r') as file:
                try:
                    json_data = json.load(file)
                    print(f"Processing file: {filename}")
                    for entry in json_data:
                        for var_name, json_key in VARIABLES.items():
                            if json_key in entry:
                                data[client_name][var_name].append(entry[json_key])
                except json.JSONDecodeError:
                    print(f"Error decoding JSON in file: {filename}")
    return data

def plot_data(data):
    print(data)
    # Plot data for each metric
    for metric in ["packet_loss", "ping"]:
        plt.figure()
        for client_name, client_data in data.items():
            # Convert time from milliseconds to seconds
            time_in_seconds = [t / 1000 for t in client_data["time"]]
            
            # Filter data to include only time values between 100 and 600 seconds
            filtered_time = []
            filtered_metric = []
            for i, t in enumerate(time_in_seconds):
                if 100 <= t <= 600:
                    filtered_time.append(t)
                    filtered_metric.append(client_data[metric][i])
            
            # Plot the filtered data
            plt.plot(filtered_time, filtered_metric, linestyle='-', label=client_name)
        
        plt.title(f"Graph for {metric.capitalize()}")
        plt.xlabel("Time (s)")
        plt.ylabel(metric.capitalize())
        plt.grid(True)
        plt.legend()
        # plt.savefig(f"{metric}_graph.png")  # Save the graph as an image
        plt.show()

if __name__ == "__main__":
    json_directory = "./jsonfiles"  # Replace with your JSON files directory
    extracted_data = extract_data_from_json(json_directory)
    if extracted_data:
        plot_data(extracted_data)
    else:
        print("No data found to plot.")
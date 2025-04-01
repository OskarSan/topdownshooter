#Script created using Github Copilot


import json
import os

import matplotlib.pyplot as plt

def extract_data_from_json(directory):
    data = {"Client": [], "packet_loss": [], "ping": [], "time": []}
    for filename in os.listdir(directory):
        if filename.endswith(".json"):
            filepath = os.path.join(directory, filename)
            with open(filepath, 'r') as file:
                try:
                    json_data = json.load(file)
                    print(f"Processing file: {filename}")
                    for entry in json_data:
                        for key in data.keys():
                            if key in entry:
                                data[key].append(entry[key])
                except json.JSONDecodeError:
                    print(f"Error decoding JSON in file: {filename}")
    return data

def plot_data(data):
    print(data)
    time_in_seconds = [t / 1000 for t in data["time"]]
    # Group data by Client
    clients = set(data["Client"])  # Get unique client IDs
    grouped_data = {client: {"time": [], "packet_loss": [], "ping": []} for client in clients}
    
    for i, client in enumerate(data["Client"]):
        grouped_data[client]["time"].append(time_in_seconds[i])
        grouped_data[client]["packet_loss"].append(data["packet_loss"][i])
        grouped_data[client]["ping"].append(data["ping"][i])
    
    # Plot data for each metric
    for metric in ["packet_loss", "ping"]:
        plt.figure()
        for client, client_data in grouped_data.items():
            plt.plot(client_data["time"], client_data[metric], marker='o', linestyle='-', label=f"Client {client}")
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
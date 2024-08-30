# DigitalOcean Load Balancer Metrics Fetcher

![DigitalOcean Logo](https://upload.wikimedia.org/wikipedia/commons/thumb/f/ff/DigitalOcean_logo.svg/1024px-DigitalOcean_logo.svg.png)

This script, named `do_lb_metrics_fetcher.sh`, is designed to interactively fetch and display metrics for DigitalOcean Load Balancers. It allows users to select a specific load balancer and metric category, then retrieves and displays metrics for predefined time periods.

## Features

- **Interactive Load Balancer Selection**: Choose from a list of available load balancers.
- **Categorized Metric Retrieval**: Select metrics grouped by category such as Frontend Metrics, Droplet-Level Metrics, and Network-Level Metrics.
- **Predefined Time Periods**: Automatically fetch metrics for the last 1 hour, 24 hours, 3 days, and 7 days.
- **Cross-platform Compatibility**: Supports Unix-like environments including Linux and macOS.

## Prerequisites

- **Bash Shell**: The script requires Bash version 4.0 or higher. You can check your Bash version by running `bash --version`.
- **Curl**: This script uses `curl` for making API calls.
- **jq**: This script uses `jq` for parsing JSON responses. It must be installed on your system.
- **DigitalOcean API Token**: A valid DigitalOcean API token is required for authentication.

## Setup

1. **Install jq**:

   - On Ubuntu: `sudo apt-get install jq`
   - On macOS: `brew install jq`

2. **Export your DigitalOcean API Token**:
   ```bash
   export DO_API_TOKEN="your_digital_ocean_api_token_here"
   ```
3. **Download the Script**:
   Download or clone the script from the repository to your local machine.

## Usage

1. **Make the script executable**:

```bash
chmod +x do_lb_metrics_fetcher.sh
```

2. **Run the script**:

```bash
./do_lb_metrics_fetcher.sh
```

Follow the interactive prompts to select a load balancer and the type of metrics you wish to retrieve.

## Troubleshooting

- **API Token Not Recognized**: Ensure that the `DO_API_TOKEN` environment variable is set correctly.
- **Permission Issues**: If the script fails to execute, check that it has the appropriate executable permissions.
- **Connectivity Issues**: Ensure your machine has a stable internet connection and can access DigitalOcean APIs.
- **jq Not Found**: If you receive an error regarding `jq`, ensure it is installed and correctly pathed on your system.
- **Bash Version Incompatibility**: Ensure your system is running Bash version 4.0 or higher. Some advanced scripting features may not work in older versions.

## Support

For support, please check the troubleshooting section. If you encounter issues beyond the provided solutions, contact support via your preferred method or submit an issue in the repository.

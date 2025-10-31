import requests
import json
from pathlib import Path


def validate_sail(file_path: str) -> dict:
    """
    Validates SAIL code by making a web API call to the Appian endpoint.

    Args:
        file_path: A string containing the path to a text file with the SAIL code

    Returns:
        dict: JSON response from the API. The JSON object will contain two entries.
              The first one is "hasErrors" and will be true if there are errors in the SAIL code.
              The second one is "errorMsg" and will contain the error message if any.

    Raises:
        requests.exceptions.RequestException: If the API call fails
        FileNotFoundError: If the file path does not exist
        IOError: If there's an error reading the file
    """
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            sail_code = file.read()
    except FileNotFoundError:
        raise FileNotFoundError(f"File not found: {file_path}")
    except IOError as e:
        raise IOError(f"Error reading file: {str(e)}")

    # https://aic-daily.appian-sites.net/suite/design/koBOn9qWefpAjXQIQV1VzdpamFUkIxbzjxFFFzSw3OEWrmAO0kubKw8D2uXlK-deS3EqXIg-mYo3gXCZAO7g9AjoW1QT7Zc2MiNdQ
    url = "https://aic-daily.appian-sites.net/suite/webapi/l1xckQ"

    payload = {
        "sail_code": sail_code
    }

    headers = {
        "Content-Type": "application/json"
    }

    auth = ("admin.user", "ineedtoadminister")

    try:
        with open('scripts/log.txt', 'a', encoding='utf-8') as log_file:
            log_file.write(f'{file_path=}, {payload=}\n')

            response = requests.post(url, json=payload, headers=headers, auth=auth)
            response.raise_for_status()
            print(f'{response.status_code=}, {response.text=}')

            log_file.write(f'{response.status_code=}, {response.text=}\n')

        return response.json()
    except requests.exceptions.RequestException as e:
        raise Exception(f"API call failed: {str(e)}")

if __name__ == "__main__":
    import sys

    if len(sys.argv) != 2:
        print("Usage: python validate_sail.py <path_to_sail_file>")
        sys.exit(1)

    sail_file_path = sys.argv[1]

    assert Path(sail_file_path).exists(), f"File does not exist: {sail_file_path}"

    try:
        result = validate_sail(sail_file_path)
        print(json.dumps(result, indent=4))
    except Exception as e:
        print(f"Error: {str(e)}")
        sys.exit(1)
def write_json_to_dzn(json_obj, filepath):
    try:
        with open(filepath, 'w') as file:
            for key, value in json_obj.items():
                file.write(f"{key}={value};\n")
        print(f"JSON data written to {filepath}")
    except Exception as e:
        print(f"An error occurred: {e}")
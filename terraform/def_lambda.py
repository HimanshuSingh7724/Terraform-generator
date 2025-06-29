def lambda_handler(event, context):
    try:
        number = int(event.get("number", 0))
        reversed_number = int(str(abs(number))[::-1])  # Reverse digits
        if number < 0:
            reversed_number = -reversed_number

        return {
            "statusCode": 200,
            "original": number,
            "reversed": reversed_number
        }
    except ValueError:
        return {
            "statusCode": 400,
            "error": "Invalid input. Please provide a valid number."
        }

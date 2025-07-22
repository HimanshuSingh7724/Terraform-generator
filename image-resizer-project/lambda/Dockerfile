FROM public.ecr.aws/lambda/python:3.9

# Install dependencies
RUN pip install pillow boto3

# Copy your lambda function code
COPY app.py ./

# Command Lambda runtime uses to start the function
CMD ["app.handler"]

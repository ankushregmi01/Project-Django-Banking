FROM python:3.9-slim as builder

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .
RUN python manage.py collectstatic --noinput

FROM gcr.io/distroless/python3

WORKDIR /app

COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
COPY --from=builder /app .

ENV DJANGO_SETTINGS_MODULE=nkbank.settings

EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"] 
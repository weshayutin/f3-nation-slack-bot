#!/bin/bash

set -e

echo "🚀 Starting F3 Database Initialization..."

# Function to wait for database to be ready
wait_for_db() {
    echo "📡 Waiting for database to be ready..."
    
    # Default database connection parameters
    DB_HOST=${DATABASE_HOST:-localhost}
    DB_USER=${DATABASE_USER:-postgres}
    DB_PASS=${DATABASE_PASSWORD:-postgres}
    DB_NAME=${DATABASE_SCHEMA:-f3}
    
    # Wait for PostgreSQL to be ready
    until PGPASSWORD=$DB_PASS psql -h "$DB_HOST" -U "$DB_USER" -d postgres -c '\q' 2>/dev/null; do
        echo "🔄 Database is unavailable - sleeping..."
        sleep 5
    done
    
    echo "✅ Database is ready!"
}

# Function to create database if it doesn't exist
create_database() {
    echo "🔧 Checking if database '$DATABASE_SCHEMA' exists..."
    
    DB_EXISTS=$(PGPASSWORD=$DATABASE_PASSWORD psql -h "$DATABASE_HOST" -U "$DATABASE_USER" -d postgres -tAc "SELECT 1 FROM pg_database WHERE datname='$DATABASE_SCHEMA'" 2>/dev/null || echo "")
    
    if [ -z "$DB_EXISTS" ]; then
        echo "🏗️ Creating database '$DATABASE_SCHEMA'..."
        PGPASSWORD=$DATABASE_PASSWORD createdb -h "$DATABASE_HOST" -U "$DATABASE_USER" "$DATABASE_SCHEMA"
        echo "✅ Database '$DATABASE_SCHEMA' created!"
    else
        echo "✅ Database '$DATABASE_SCHEMA' already exists!"
    fi
}

# Function to run migrations
run_migrations() {
    echo "🗄️ Running Alembic migrations..."
    
    # Run the migrations
    poetry env use $PYTHON_VERSION
    poetry install
    poetry run alembic upgrade head
    
    echo "✅ Database schema created successfully!"
}

# Main execution
main() {
    # Install postgresql-client for database operations
    apt-get update && apt-get install -y postgresql-client && rm -rf /var/lib/apt/lists/*
    
    wait_for_db
    create_database
    run_migrations
    
    echo "🎉 F3 Database initialization completed successfully!"
    echo "📊 Database is ready for the F3 Nation Slack Bot!"
}

# Run main function
main "$@" 
#!/usr/bin/env python3
import requests
import json
import time
import random
import sys
import os
from datetime import datetime

# Get the backend URL from the frontend .env file
def get_backend_url():
    with open('/app/frontend/.env', 'r') as f:
        for line in f:
            if line.startswith('REACT_APP_BACKEND_URL='):
                return line.strip().split('=')[1].strip('"\'')
    return None

# Base URL for API requests
BASE_URL = f"{get_backend_url()}/api"
print(f"Using backend URL: {BASE_URL}")

# Test user data
TEST_USER = {
    "email": f"test.user{random.randint(1000, 9999)}@example.com",
    "full_name": "Test User",
    "phone": "+1234567890",
    "password": "TestPassword123!"
}

# Global variables to store test data
auth_token = None
user_id = None
ride_id = None
trip_id = None

# Helper function to make API requests
def api_request(method, endpoint, data=None, token=None, params=None):
    url = f"{BASE_URL}{endpoint}"
    headers = {"Content-Type": "application/json"}
    
    if token:
        headers["Authorization"] = f"Bearer {token}"
    
    try:
        if method == "GET":
            response = requests.get(url, headers=headers, params=params)
        elif method == "POST":
            response = requests.post(url, headers=headers, json=data, params=params)
        elif method == "PUT":
            response = requests.put(url, headers=headers, json=data)
        elif method == "DELETE":
            response = requests.delete(url, headers=headers)
        else:
            raise ValueError(f"Unsupported HTTP method: {method}")
        
        return response
    except requests.exceptions.RequestException as e:
        print(f"Request error: {e}")
        return None

# Test health endpoint
def test_health():
    print("\n=== Testing Health Endpoint ===")
    response = api_request("GET", "/health")
    
    if response and response.status_code == 200:
        data = response.json()
        print(f"Health check successful: {data}")
        return True
    else:
        print(f"Health check failed: {response.status_code if response else 'No response'}")
        return False

# Test root endpoint
def test_root():
    print("\n=== Testing Root Endpoint ===")
    response = api_request("GET", "/")
    
    if response and response.status_code == 200:
        data = response.json()
        print(f"Root endpoint successful: {data}")
        return True
    else:
        print(f"Root endpoint failed: {response.status_code if response else 'No response'}")
        return False

# Test user registration
def test_registration():
    print("\n=== Testing User Registration ===")
    response = api_request("POST", "/auth/register", TEST_USER)
    
    if response and response.status_code == 200:
        data = response.json()
        print(f"Registration successful: {data['email']}")
        return True
    else:
        print(f"Registration failed: {response.json() if response else 'No response'}")
        return False

# Test user login
def test_login():
    print("\n=== Testing User Login ===")
    login_data = {
        "email": TEST_USER["email"],
        "password": TEST_USER["password"]
    }
    
    response = api_request("POST", "/auth/login", login_data)
    
    if response and response.status_code == 200:
        data = response.json()
        global auth_token, user_id
        auth_token = data["access_token"]
        user_id = data["user"]["id"]
        print(f"Login successful: {data['user']['email']}")
        print(f"Token: {auth_token[:10]}...")
        return True
    else:
        print(f"Login failed: {response.json() if response else 'No response'}")
        return False

# Test get user profile
def test_get_profile():
    print("\n=== Testing Get User Profile ===")
    response = api_request("GET", "/users/me", token=auth_token)
    
    if response and response.status_code == 200:
        data = response.json()
        print(f"Get profile successful: {data['email']}")
        return True
    else:
        print(f"Get profile failed: {response.json() if response else 'No response'}")
        return False

# Test update user profile
def test_update_profile():
    print("\n=== Testing Update User Profile ===")
    update_data = {
        "full_name": f"Updated User {random.randint(100, 999)}",
        "phone": "+1987654321"
    }
    
    response = api_request("PUT", "/users/me", update_data, token=auth_token)
    
    if response and response.status_code == 200:
        data = response.json()
        print(f"Update profile successful: {data['full_name']}")
        return True
    else:
        print(f"Update profile failed: {response.json() if response else 'No response'}")
        return False

# Test get discovery items
def test_get_discovery():
    print("\n=== Testing Get Discovery Items ===")
    response = api_request("GET", "/discovery")
    
    if response and response.status_code == 200:
        data = response.json()
        print(f"Get discovery successful: {len(data)} items")
        for item in data[:2]:  # Print first 2 items
            print(f"  - {item['title']}: {item['estimated_fare']}")
        return True
    else:
        print(f"Get discovery failed: {response.json() if response else 'No response'}")
        return False

# Test create discovery item
def test_create_discovery():
    print("\n=== Testing Create Discovery Item ===")
    discovery_data = {
        "title": f"Test Location {random.randint(100, 999)}",
        "location": {
            "address": "123 Test Street",
            "latitude": 40.7128,
            "longitude": -74.0060,
            "place_id": "test123"
        },
        "estimated_fare": 15.0,
        "estimated_time": "10 min",
        "rating": 4.7,
        "popularity_score": 75,
        "tags": ["test", "api"],
        "is_featured": False
    }
    
    response = api_request("POST", "/discovery", discovery_data, token=auth_token)
    
    if response and response.status_code == 200:
        data = response.json()
        print(f"Create discovery successful: {data['title']}")
        return True
    else:
        print(f"Create discovery failed: {response.json() if response else 'No response'}")
        return False

# Test get ride options
def test_get_ride_options():
    print("\n=== Testing Get Ride Options ===")
    params = {
        "pickup_lat": 40.7128,
        "pickup_lng": -74.0060,
        "dest_lat": 40.7589,
        "dest_lng": -73.9851
    }
    
    response = api_request("POST", "/rides/options", params=params)
    
    if response and response.status_code == 200:
        data = response.json()
        print(f"Get ride options successful: {len(data)} options")
        for option in data:
            print(f"  - {option['type']}: {option['estimated_fare']}")
        return True
    else:
        print(f"Get ride options failed: {response.json() if response else 'No response'}")
        return False

# Test create ride request
def test_create_ride():
    print("\n=== Testing Create Ride Request ===")
    ride_data = {
        "pickup_location": {
            "address": "123 Pickup Street",
            "latitude": 40.7128,
            "longitude": -74.0060,
            "place_id": "pickup123"
        },
        "destination_location": {
            "address": "456 Destination Avenue",
            "latitude": 40.7589,
            "longitude": -73.9851,
            "place_id": "dest456"
        },
        "ride_type": "V-Economy",
        "estimated_fare": 15.0,
        "notes": "Test ride request"
    }
    
    response = api_request("POST", "/rides", ride_data, token=auth_token)
    
    if response and response.status_code == 200:
        data = response.json()
        global ride_id
        ride_id = data["id"]
        print(f"Create ride successful: {data['id']}")
        return True
    else:
        print(f"Create ride failed: {response.json() if response else 'No response'}")
        return False

# Test get user rides
def test_get_rides():
    print("\n=== Testing Get User Rides ===")
    response = api_request("GET", "/rides", token=auth_token)
    
    if response and response.status_code == 200:
        data = response.json()
        print(f"Get rides successful: {len(data)} rides")
        return True
    else:
        print(f"Get rides failed: {response.json() if response else 'No response'}")
        return False

# Test get specific ride
def test_get_ride():
    print("\n=== Testing Get Specific Ride ===")
    if not ride_id:
        print("Skipping test: No ride ID available")
        return False
    
    response = api_request("GET", f"/rides/{ride_id}", token=auth_token)
    
    if response and response.status_code == 200:
        data = response.json()
        print(f"Get ride successful: {data['id']}")
        return True
    else:
        print(f"Get ride failed: {response.json() if response else 'No response'}")
        return False

# Test create trip
def test_create_trip():
    print("\n=== Testing Create Trip ===")
    trip_data = {
        "user_id": user_id,
        "pickup_location": {
            "address": "123 Pickup Street",
            "latitude": 40.7128,
            "longitude": -74.0060,
            "place_id": "pickup123"
        },
        "destination_location": {
            "address": "456 Destination Avenue",
            "latitude": 40.7589,
            "longitude": -73.9851,
            "place_id": "dest456"
        },
        "ride_type": "V-Economy",
        "fare": 15.0,
        "duration_minutes": 20,
        "distance_km": 5.2,
        "driver_id": "driver123",
        "driver_name": "Test Driver",
        "driver_rating": 4.8
    }
    
    response = api_request("POST", "/trips", trip_data, token=auth_token)
    
    if response and response.status_code == 200:
        data = response.json()
        global trip_id
        trip_id = data["id"]
        print(f"Create trip successful: {data['id']}")
        return True
    else:
        print(f"Create trip failed: {response.json() if response else 'No response'}")
        return False

# Test get user trips
def test_get_trips():
    print("\n=== Testing Get User Trips ===")
    response = api_request("GET", "/trips", token=auth_token)
    
    if response and response.status_code == 200:
        data = response.json()
        print(f"Get trips successful: {len(data)} trips")
        return True
    else:
        print(f"Get trips failed: {response.json() if response else 'No response'}")
        return False

# Test error handling
def test_error_handling():
    print("\n=== Testing Error Handling ===")
    
    # Test invalid login
    print("Testing invalid login...")
    invalid_login = {
        "email": "nonexistent@example.com",
        "password": "wrongpassword"
    }
    response = api_request("POST", "/auth/login", invalid_login)
    if response and response.status_code == 401:
        print("  ✓ Invalid login correctly returns 401")
    else:
        print(f"  ✗ Invalid login test failed: {response.status_code if response else 'No response'}")
    
    # Test unauthorized access
    print("Testing unauthorized access...")
    response = api_request("GET", "/users/me")
    if response and response.status_code == 401:
        print("  ✓ Unauthorized access correctly returns 401")
    else:
        print(f"  ✗ Unauthorized access test failed: {response.status_code if response else 'No response'}")
    
    # Test invalid ride ID
    print("Testing invalid ride ID...")
    response = api_request("GET", "/rides/invalid-id", token=auth_token)
    if response and response.status_code == 404:
        print("  ✓ Invalid ride ID correctly returns 404")
    else:
        print(f"  ✗ Invalid ride ID test failed: {response.status_code if response else 'No response'}")
    
    return True

# Run all tests
def run_tests():
    print("\n========== STARTING BACKEND API TESTS ==========")
    print(f"Test time: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    
    tests = [
        ("Health Check", test_health),
        ("Root Endpoint", test_root),
        ("User Registration", test_registration),
        ("User Login", test_login),
        ("Get User Profile", test_get_profile),
        ("Update User Profile", test_update_profile),
        ("Get Discovery Items", test_get_discovery),
        ("Create Discovery Item", test_create_discovery),
        ("Get Ride Options", test_get_ride_options),
        ("Create Ride Request", test_create_ride),
        ("Get User Rides", test_get_rides),
        ("Get Specific Ride", test_get_ride),
        ("Create Trip", test_create_trip),
        ("Get User Trips", test_get_trips),
        ("Error Handling", test_error_handling)
    ]
    
    results = {}
    all_passed = True
    
    for name, test_func in tests:
        try:
            result = test_func()
            results[name] = result
            if not result:
                all_passed = False
        except Exception as e:
            print(f"Error in {name}: {e}")
            results[name] = False
            all_passed = False
    
    # Print summary
    print("\n========== TEST SUMMARY ==========")
    for name, result in results.items():
        status = "✅ PASSED" if result else "❌ FAILED"
        print(f"{name}: {status}")
    
    overall = "✅ ALL TESTS PASSED" if all_passed else "❌ SOME TESTS FAILED"
    print(f"\nOverall: {overall}")
    
    return all_passed, results

if __name__ == "__main__":
    run_tests()
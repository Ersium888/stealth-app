import axios from 'axios';

const BACKEND_URL = process.env.REACT_APP_BACKEND_URL;
const API_BASE = `${BACKEND_URL}/api`;

// Create axios instance
const api = axios.create({
  baseURL: API_BASE,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Token management
const getToken = () => localStorage.getItem('token');
const setToken = (token) => localStorage.setItem('token', token);
const removeToken = () => localStorage.removeItem('token');

// Request interceptor to add token
api.interceptors.request.use(
  (config) => {
    const token = getToken();
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => Promise.reject(error)
);

// Response interceptor to handle token expiration
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      removeToken();
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

// Auth API
export const authAPI = {
  register: async (userData) => {
    const response = await api.post('/auth/register', userData);
    return response.data;
  },
  
  login: async (credentials) => {
    const response = await api.post('/auth/login', credentials);
    if (response.data.access_token) {
      setToken(response.data.access_token);
    }
    return response.data;
  },
  
  logout: () => {
    removeToken();
  },
  
  getCurrentUser: async () => {
    const response = await api.get('/users/me');
    return response.data;
  },
  
  updateProfile: async (userData) => {
    const response = await api.put('/users/me', userData);
    return response.data;
  }
};

// Discovery API
export const discoveryAPI = {
  getDiscoveryItems: async () => {
    const response = await api.get('/discovery');
    return response.data;
  },
  
  createDiscoveryItem: async (item) => {
    const response = await api.post('/discovery', item);
    return response.data;
  }
};

// Ride API
export const rideAPI = {
  getRideOptions: async (pickupLat, pickupLng, destLat, destLng) => {
    const response = await api.post('/rides/options', {
      pickup_lat: pickupLat,
      pickup_lng: pickupLng,
      dest_lat: destLat,
      dest_lng: destLng
    });
    return response.data;
  },
  
  createRideRequest: async (rideData) => {
    const response = await api.post('/rides', rideData);
    return response.data;
  },
  
  getUserRides: async () => {
    const response = await api.get('/rides');
    return response.data;
  },
  
  getRide: async (rideId) => {
    const response = await api.get(`/rides/${rideId}`);
    return response.data;
  }
};

// Trip API
export const tripAPI = {
  getUserTrips: async () => {
    const response = await api.get('/trips');
    return response.data;
  },
  
  createTrip: async (tripData) => {
    const response = await api.post('/trips', tripData);
    return response.data;
  }
};

// Health check
export const healthCheck = async () => {
  const response = await api.get('/health');
  return response.data;
};

export default api;
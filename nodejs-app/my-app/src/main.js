import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import axios from 'axios';
import './style.css'

const baseUrl = window.location.origin;

axios.defaults.withCredentials = true;

axios.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';

const instance = axios.create({
	baseURL: baseUrl,
	headers: {
		'X-Requested-With': 'XMLHttpRequest'
	},
	params: {}
});

window.API = instance;

const app = createApp(App)

app.use(router)

app.mount('#app')

<template>
  <div class="flex flex-col justify-center flex-1 min-h-full px-6 py-12 lg:px-8">
    <div class="sm:mx-auto sm:w-full sm:max-w-sm">
      <!-- <img class="w-auto h-10 mx-auto" src="https://tailwindui.com/img/logos/mark.svg?color=indigo&shade=600" alt="Your Company" /> -->
      <h2 class="mt-10 text-2xl font-bold leading-9 tracking-tight text-center text-gray-900">Sign in to your account</h2>
    </div>

    <div class="mt-10 sm:mx-auto sm:w-full sm:max-w-sm">
      <form class="space-y-6">
        <div>
          <label for="email" class="block text-sm font-medium leading-6 text-gray-900">Username</label>
          <div class="mt-2">
            <input v-model="form.params.username" id="username" name="username" type="username" autocomplete="username" required="" class="block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6 px-4" />
          </div>
        </div>

        <div>
          <div class="flex items-center justify-between">
            <label for="password" class="block text-sm font-medium leading-6 text-gray-900">Password</label>
          </div>
          <div class="mt-2">
            <input v-model="form.params.password" id="password" name="password" type="password" autocomplete="current-password" required="" class="block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6" />
          </div>
        </div>

        <p v-if="error.message" class="text-sm leading-6 text-red-600">
            <strong class="font-semibold">ERROR</strong>
            
            Incorrect Credentials
        </p>

        <p v-if="success.message" class="text-sm leading-6 text-green-600">
            <strong class="font-semibold">SUCCESS</strong>
            
            Migration complete
        </p>

        <div>
          <button @click="login" type="submit" class="flex w-full justify-center rounded-md bg-indigo-600 px-3 py-1.5 text-sm font-semibold leading-6 text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600">Sign in</button>
        </div>

        <div>
          <button @click="migrate" type="submit" class="flex w-full justify-center rounded-md bg-indigo-600 px-3 py-1.5 text-sm font-semibold leading-6 text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600">Migrate Data</button>
        </div>
      </form>

    </div>


  </div>


</template>

<script setup>

import { ref, reactive, computed, onMounted, watch } from 'vue';
import { useRouter, useRoute } from 'vue-router';
const router = useRouter();
const route = useRoute();

let error = reactive({
  message: null
})

let success = reactive({
  message: null
})

let form = reactive({
  params: {}
})

const migrate = (e) => {
    // e.preventDefault();
		API.get(`/api/migrate`)
			.then((response) => {

        // console.log(response.data.status);

        if (response.data.status == 'error') {
          // error.message = response.data
          // console.log(error.message);
          return
        }

        success.message = response.data

        // sessionStorage.setItem('token',response.data.data.token);
        // router.push('/manage');
			})
			.catch(function (e) {
				console.error(e);
			});
};

const login = (e) => {
    e.preventDefault();
		API.post(`/api/login`, form.params)
			.then((response) => {

        // console.log(response.data.status);

        if (response.data.status == 'error') {
          error.message = response.data
          console.log(error.message);
          return
        }

        sessionStorage.setItem('token',response.data.data.token);
        router.push('/manage');
			})
			.catch(function (e) {
				console.error(e);
			});
};

</script>

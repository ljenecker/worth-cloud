<template>
  <div class="min-h-full">

      <div class="py-6 mx-auto max-w-7xl sm:px-6 lg:px-8">
        <div class="px-4 sm:px-6 lg:px-8">
    <div class="sm:flex sm:items-center">
      <div class="sm:flex-auto">
        <h1 class="text-base font-semibold leading-6 text-gray-900">People</h1>
        <p class="mt-2 text-sm text-gray-700">A list of all the people in your system.</p>
      </div>
      <div class="mt-4 sm:ml-16 sm:mt-0 sm:flex-none">
        <button type="button" class="block px-3 py-2 text-sm font-semibold text-center text-white bg-indigo-600 rounded-md shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600">Add person</button>
      </div>
    </div>
    <div class="flow-root mt-8">
      <div class="-mx-4 -my-2 overflow-x-auto sm:-mx-6 lg:-mx-8">
        <div class="inline-block min-w-full py-2 align-middle">
          <table class="min-w-full divide-y divide-gray-300">
            <thead>
              <tr>
                <th scope="col" class="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-gray-900 sm:pl-6 lg:pl-8">Name</th>
                <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900">Role</th>
                <th scope="col" class="relative py-3.5 pl-3 pr-4 sm:pr-6 lg:pr-8">
                  <span class="sr-only">Edit</span>
                </th>
              </tr>
            </thead>
            <tbody class="bg-white divide-y divide-gray-200">
              <tr v-for="person in form.params.people" :key="person.email">
                <td class="py-4 pl-4 pr-3 text-sm font-medium text-gray-900 whitespace-nowrap sm:pl-6 lg:pl-8">{{ person.username }}</td>
                <td class="px-3 py-4 text-sm text-gray-500 whitespace-nowrap">{{ person.role }}</td>
                <td class="relative py-4 pl-3 pr-4 text-sm font-medium text-right whitespace-nowrap sm:pr-6 lg:pr-8">
                  <a href="#" class="text-indigo-600 hover:text-indigo-900"
                    >Edit<span class="sr-only">, {{ person.username }}</span></a
                  >
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
      </div>

  </div>
</template>

<script setup>
import { Disclosure, DisclosureButton, DisclosurePanel, Menu, MenuButton, MenuItem, MenuItems } from '@headlessui/vue'
import { Bars3Icon, BellIcon, XMarkIcon } from '@heroicons/vue/24/outline'
import { ref, reactive, computed, onMounted, watch } from 'vue';

let form = reactive({
  params: {
    people: null
  }
})

onMounted(() => {
	getPeople();
});

const getPeople = async (e) => {
    
		API.get(`/api/people`)
			.then((response) => {

        // console.log(response.data);

        form.params.people = response.data.data

        // console.log(form.params);

        // if (response.data.status == 'error') {
        //   error.message = response.data
        //   console.log(error.message);
        //   return
        // }

        // sessionStorage.setItem('token',response.data.data.token);
        // router.push('/manage');
			})
			.catch(function (e) {
				console.error(e);
			});
};


</script>
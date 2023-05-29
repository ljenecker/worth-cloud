<template>
	<div class="min-h-full pb-8">
		<header class="shadow-sm">
			<Disclosure as="nav" class="bg-gray-800" v-slot="{ open }">
      <div class="px-4 mx-auto max-w-7xl sm:px-6 lg:px-8">
        <div class="flex items-center justify-between h-16">
          <div class="flex items-center">
            <div class="flex-shrink-0">
              <img class="w-8 h-8" src="https://tailwindui.com/img/logos/mark.svg?color=indigo&shade=500" alt="Your Company" />
            </div>
            <div class="hidden md:block">
              <div class="flex items-baseline ml-10 space-x-4">

              <template v-for="item in navigation" :key="item.name">

                <router-link
                  
                  :to="item.href"
                >
                <a :class="[item.href == route.fullPath ? 'bg-gray-900 text-white' : 'text-gray-300 hover:bg-gray-700 hover:text-white', 'rounded-md px-3 py-2 text-sm font-medium']" :aria-current="item.current ? 'page' : undefined">{{ item.name }}</a>
                </router-link>

              </template>
               
              </div>
            </div>
          </div>
          <div class="hidden md:block">
            <div class="flex items-center ml-4 md:ml-6">
              <!-- <button type="button" class="p-1 text-gray-400 bg-gray-800 rounded-full hover:text-white focus:outline-none focus:ring-2 focus:ring-white focus:ring-offset-2 focus:ring-offset-gray-800">
                <span class="sr-only">View notifications</span>
                <BellIcon class="w-6 h-6" aria-hidden="true" />
              </button> -->

              <!-- Profile dropdown -->
              <Menu as="div" class="relative ml-3">
                <!-- <div>
                  <MenuButton class="flex items-center max-w-xs text-sm text-white bg-gray-800 rounded-full focus:outline-none focus:ring-2 focus:ring-white focus:ring-offset-2 focus:ring-offset-gray-800">
                    <span class="sr-only">Open user menu</span>
                    <img class="w-8 h-8 rounded-full" :src="user.imageUrl" alt="" />
                  </MenuButton>
                </div> -->
                <!-- <transition enter-active-class="transition duration-100 ease-out" enter-from-class="transform scale-95 opacity-0" enter-to-class="transform scale-100 opacity-100" leave-active-class="transition duration-75 ease-in" leave-from-class="transform scale-100 opacity-100" leave-to-class="transform scale-95 opacity-0">
                  <MenuItems class="absolute right-0 z-10 w-48 py-1 mt-2 origin-top-right bg-white rounded-md shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none">
                    <MenuItem v-for="item in userNavigation" :key="item.name" v-slot="{ active }">
                      <a :href="item.href" :class="[active ? 'bg-gray-100' : '', 'block px-4 py-2 text-sm text-gray-700']">{{ item.name }}</a>
                    </MenuItem>
                  </MenuItems>
                </transition> -->
              </Menu>
            </div>
          </div>
          <div class="flex -mr-2 md:hidden">
            <!-- Mobile menu button -->
            <DisclosureButton class="inline-flex items-center justify-center p-2 text-gray-400 bg-gray-800 rounded-md hover:bg-gray-700 hover:text-white focus:outline-none focus:ring-2 focus:ring-white focus:ring-offset-2 focus:ring-offset-gray-800">
              <span class="sr-only">Open main menu</span>
              <Bars3Icon v-if="!open" class="block w-6 h-6" aria-hidden="true" />
              <XMarkIcon v-else class="block w-6 h-6" aria-hidden="true" />
            </DisclosureButton>
          </div>
        </div>
      </div>

      <DisclosurePanel class="md:hidden">
        <div class="px-2 pt-2 pb-3 space-y-1 sm:px-3">

          <template v-for="item in navigation" :key="item.name">

<router-link
  
  :to="item.href"
>
<DisclosureButton as="a" :class="[item.href == route.fullPath  ? 'bg-gray-900 text-white' : 'text-gray-300 hover:bg-gray-700 hover:text-white', 'block rounded-md px-3 py-2 text-base font-medium']" :aria-current="item.current ? 'page' : undefined">{{ item.name }}</DisclosureButton>
</router-link>

</template>


          
        </div>
        <!-- <div class="pt-4 pb-3 border-t border-gray-700">
          <div class="flex items-center px-5">
            <div class="flex-shrink-0">
              <img class="w-10 h-10 rounded-full" :src="user.imageUrl" alt="" />
            </div>
            <div class="ml-3">
              <div class="text-base font-medium text-white">{{ user.name }}</div>
              <div class="text-sm font-medium text-gray-400">{{ user.email }}</div>
            </div>
            <button type="button" class="flex-shrink-0 p-1 ml-auto text-gray-400 bg-gray-800 rounded-full hover:text-white focus:outline-none focus:ring-2 focus:ring-white focus:ring-offset-2 focus:ring-offset-gray-800">
              <span class="sr-only">View notifications</span>
              <BellIcon class="w-6 h-6" aria-hidden="true" />
            </button>
          </div>
          <div class="px-2 mt-3 space-y-1">
            <DisclosureButton v-for="item in userNavigation" :key="item.name" as="a" :href="item.href" class="block px-3 py-2 text-base font-medium text-gray-400 rounded-md hover:bg-gray-700 hover:text-white">{{ item.name }}</DisclosureButton>
          </div>
        </div> -->
      </DisclosurePanel>
    </Disclosure>
		</header>
		<main class="">
			<div class="px-4 mx-auto mt-10 max-w-8xl">
				<router-view
					:key="$route.fullPath"
					v-slot="{ Component }"
				>
					<transition
						:duration="{
							enter: 50,
							leave: 50
						}"
						enter-active-class="animate__animated animate__fadeIn"
						leave-active-class="animate__animated animate__fadeOut"
						mode="out-in"
					>
						<component :is="Component" />
					</transition>
				</router-view>
			</div>
		</main>
	</div>
</template>

<script setup>
import { useRouter, useRoute } from 'vue-router';
import { Disclosure, DisclosureButton, DisclosurePanel, Menu, MenuButton, MenuItem, MenuItems } from '@headlessui/vue'
import { Bars3Icon, BellIcon, XMarkIcon } from '@heroicons/vue/24/outline'

const user = {
  name: 'Tom Cook',
  email: 'tom@example.com',
  imageUrl:
    'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80',
}
const navigation = [
  { name: 'Dashboard', href: '/manage/dashboard', current: true },
  { name: 'People', href: '/manage/people', current: false },
  { name: 'News', href: '/manage/news', current: false },
]
const userNavigation = [
  { name: 'Your Profile', href: '#' },
  { name: 'Settings', href: '#' },
  { name: 'Sign out', href: '#' },
]


const router = useRouter();
const route = useRoute();

// console.log(route);
</script>

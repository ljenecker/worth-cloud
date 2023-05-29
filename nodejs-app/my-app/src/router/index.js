import { createRouter, createWebHistory } from 'vue-router'
import Layout from '../layouts/Layout.vue'
import LoginView from '../views/LoginView.vue'
import DashboardView from '../views/DashboardView.vue'
import PeopleView from '../views/PeopleView.vue'
import NewsView from '../views/NewsView.vue'

export const routes = [

    {
      path: '/',
      name: 'login',
      component: LoginView
    },
    {
      name: 'manage',
      path: '/manage',
      redirect: '/manage/dashboard',
      component: Layout,
      meta: {
        // middleware: ['superadmin', 'admin', 'user'],
        title: `Manage`
      },
      children: [
        {
          path: '/manage/dashboard',
          name: 'Dashboard',
          meta: {
            // middleware: ['superadmin', 'admin', 'user'],
            title: `Dashboard`
          },
          components: {
            default: DashboardView
          }
        },
        {
          path: '/manage/people',
          name: 'People',
          meta: {
            // middleware: ['superadmin'],
            title: `People`
          },
          components: {
            default: PeopleView
          }
        },
        {
          path: '/manage/news',
          name: 'News',
          meta: {
            // middleware: ['superadmin'],
            title: `News`
          },
          components: {
            default: NewsView
          }
        }
      ]
      },
      {
        path: '/:catchAll(.*)', // Unrecognized path automatically matches 404
        redirect: '/manage'
      }
  ]

  const router = createRouter({
    history: createWebHistory(),
    routes: routes
  });





export default router

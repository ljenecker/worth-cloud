FROM public.ecr.aws/docker/library/node:16 AS ui-build
WORKDIR /usr/src/app
COPY my-app/ ./my-app/
RUN cd my-app && npm install && npm run build

FROM public.ecr.aws/docker/library/node:16 AS server-build
WORKDIR /root/
COPY --from=ui-build /usr/src/app/my-app/dist ./api/app/dist
COPY api/package*.json ./api/
RUN cd api && npm install
COPY api/ ./api/

EXPOSE 8080

CMD ["node", "./api/index.js"]


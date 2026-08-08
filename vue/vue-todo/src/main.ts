import { createApp } from "vue";
import { createPinia } from "pinia";
import App from "./App.vue";
import "./reset.css";
import "./style.css";

createApp(App).use(createPinia()).mount("#app");

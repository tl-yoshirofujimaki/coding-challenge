<script setup>
import { ref } from 'vue'
import axios from 'axios'

defineProps({
  msg: String,
})

const ampere = ref('')
const usage = ref('')
const electricityPrices = ref([])
const errorMessage = ref('')

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL

const fetchData = async () => {
  electricityPrices.value = []
  errorMessage.value = ''

  try {
    const response = await axios.get(`${API_BASE_URL}/electricity_prices`, {
      params: {
        ampere: ampere.value,
        usage: usage.value
      }
    })

    electricityPrices.value = response.data
  } catch (error) {
    errorMessage.value = error.response.data.error
  }
}
</script>

<template>
  <h1>{{ msg }}</h1>
  <label>
    <div>
      契約アンペア数(A)
      <span v-tooltip="'10 / 15 / 20 / 30 / 40 / 50 / 60 のいずれかを入力してください'" class='info'>ℹ️</span>
    </div>
    <input
      type='text'
      :value='ampere'
      @input='event => ampere = event.target.value'>
  </label>

  <label>
    <div>
      1ヶ月の使用量(kWh)
      <span v-tooltip="'0以上の整数を入力してください'" class='info'>ℹ️</span>
    </div>
    <input
      type='text'
      :value='usage'
      @input='event => usage = event.target.value'>
  </label>

  <div class='button'>
    <button @click='fetchData'>計算する</button>
  </div>

  <table v-if='electricityPrices.length' class="price-table">
    <thead>
      <tr>
        <th>電力会社</th>
        <th>プラン名</th>
        <th>料金 (円)</th>
      </tr>
    </thead>
    <tbody>
      <tr v-for='electricityPrice in electricityPrices'>
        <td>{{ electricityPrice.provider_name }}</td>
        <td>{{ electricityPrice.plan_name }}</td>
        <td>{{ electricityPrice.price }}</td>
      </tr>
    </tbody>
  </table>

  <div v-if='errorMessage' class='error'>{{ errorMessage }}</div>
</template>

<style scoped>
.info {
  cursor: pointer;
}
.button {
  margin-top: 10px;
}
.price-table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 10px;
}
.price-table th,
.price-table td {
  text-align: left;
}
.error {
  color: #f15656;
  margin-top: 10px;
}
</style>

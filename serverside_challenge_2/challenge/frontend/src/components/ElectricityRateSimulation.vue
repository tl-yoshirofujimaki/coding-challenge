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

const fetchData = async () => {
  electricityPrices.value = []
  errorMessage.value = ''

  try {
    const response = await axios.get('http://localhost:3000/electricity_prices', {
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
    <div>契約アンペア数(A)</div>
    <input
      type='text'
      :value='ampere'
      @input='event => ampere = event.target.value'>
  </label>
  <label>
    <div>1ヶ月の使用量(kWh)</div>
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

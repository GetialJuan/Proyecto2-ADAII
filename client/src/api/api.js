import axios from 'axios';
const api_url = 'http://127.0.0.1:5000'

export const solve_puente = async (data, filename) => {

    const config = {
        headers: {
            'Content-Type': 'application/json'
        }
    };

    const body = JSON.stringify({data, filename});

    try {
        const response = await axios.post(`${api_url}/solve_puente`, body, config);
        return {data: response.data, error: false};
    } catch (error) {
        return {data: error.response.data, error: true};
    }
}
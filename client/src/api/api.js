import axios from 'axios';
const api_url = 'http://127.0.0.1:5000'

export const solve_puente = async (data, filename) => {

    const config = {
        headers: {
            'Content-Type': 'application/json'
        }
    };

    const body = JSON.stringify({data, filename});

    const response = await axios.post(`${api_url}/solve_puente`, body, config);;

    return response.data;
}
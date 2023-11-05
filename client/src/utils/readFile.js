export const readFile = (fileInput) => {
    var reader = new FileReader();
    reader.readAsText(fileInput);

    return new Promise((resolve, reject) => {
        reader.onload = () => {
            const result = reader.result;
            const lineas = result.split('\n');

            const J = parseInt(lineas[0]);
            const K = parseInt(lineas[1]);
            const E = lineas[2].split(',').map((e) => parseFloat(e));
            const A = lineas[3].split(',').map((e) => parseFloat(e));
            const G = lineas[4].split(',').map((e) => parseInt(e));
            const F = lineas[5].split(',').map((e) => parseFloat(e));
            const V = lineas[6].split(',').map((e) => parseFloat(e));
            const P_inf = lineas[7].split(',').map((e) => parseFloat(e));
            const P_sup = lineas[8].split(',').map((e) => parseFloat(e));
            const Sup = lineas[9].split(',').map((e) => parseFloat(e));
            const Inf = lineas[10].split(',').map((e) => parseFloat(e));
            const P0 = lineas[11].split(',').map((e) => parseFloat(e));
            const D = lineas[12].split(',').map((e) => parseFloat(e));
            const R = lineas[13].split(',').map((e) => parseFloat(e));

            const data = {
                J,
                K,
                E,
                A,
                G,
                F,
                V,
                P_inf,
                P_sup,
                Sup,
                Inf,
                P0,
                D,
                R,
            };

            resolve(data);
        };

        reader.onerror = (error) => {
            reject(error);
        };
    });
};

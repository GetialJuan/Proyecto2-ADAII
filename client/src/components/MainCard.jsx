import { useState } from "react"
import SimpleAlert from "./SimpleAlert"
import { readFile } from "../utils/readFile"
import { solve_puente } from "../api/api"

const MainCard = () => {

    const [fileInput, setFileInput] = useState(null)
    const [error, setError] = useState(false)

    const onClickHandler = (e) => {
        e.preventDefault()
        if (fileInput == null) {
            setError(true)
            setTimeout(() => {
                setError(false)
            }, 2000)
        }
        else {
            const filename = fileInput.name.split('.')[0];
            readFile(fileInput).then(async (data) => {
                const response = await solve_puente(data, filename)
                console.log(response)
            }).catch((error) => {
                console.error(error);
            });
        }

    }

    return (
        <div>
            {error && < SimpleAlert />}
            <div className="isolate bg-white px-6 py-24 sm:py-32 lg:px-8">
                <div
                    className="absolute inset-x-0 top-[-10rem] -z-10 transform-gpu overflow-hidden blur-3xl sm:top-[-20rem]"
                    aria-hidden="true"
                >
                    <div
                        className="relative left-1/2 -z-10 aspect-[1155/678] w-[36.125rem] max-w-none -translate-x-1/2 rotate-[30deg] bg-gradient-to-tr from-[#ff80b5] to-[#9089fc] opacity-30 sm:left-[calc(50%-40rem)] sm:w-[72.1875rem]"
                        style={{
                            clipPath:
                                'polygon(74.1% 44.1%, 100% 61.6%, 97.5% 26.9%, 85.5% 0.1%, 80.7% 2%, 72.5% 32.5%, 60.2% 62.4%, 52.4% 68.1%, 47.5% 58.3%, 45.2% 34.5%, 27.5% 76.7%, 0.1% 64.9%, 17.9% 100%, 27.6% 76.8%, 76.1% 97.7%, 74.1% 44.1%)',
                        }}
                    />
                </div>
                <div className="mx-auto max-w-2xl text-center">
                    <h2 className="text-3xl font-bold tracking-tight text-gray-900 sm:text-4xl">El Problema de la Planificacion de Unidades de
Energia Termica</h2>
                    <p className="mt-2 text-lg leading-8 text-gray-600">
                        Interfaz grafica para resolver una determinada instancia PUEnTe
                    </p>
                </div>
                <form className="mx-auto mt-16 max-w-xl sm:mt-20">
                    <div className="grid grid-cols-1 gap-x-8 gap-y-6 sm:grid-cols-2">
                        <div className="sm:col-span-2">


                            <label className="block mb-2 text-sm font-medium text-gray-900 dark:text-white" htmlFor="file_input">Sube tu entrada en un txt</label>
                            <input className="block w-full text-sm text-gray-900 border border-gray-300 rounded-lg cursor-pointer bg-gray-50 dark:text-gray-400 focus:outline-none dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400" id="file_input" type="file"
                                onChange={(e) => {
                                    e.preventDefault()
                                    setFileInput(e.target.files[0])
                                }}
                            >
                            </input>


                        </div>
                    </div>

                    <div className="mt-10">
                        <button
                            onClick={onClickHandler}
                            type="submit"
                            className="block w-full rounded-md bg-indigo-600 px-3.5 py-2.5 text-center text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
                        >
                            Solucionar mi problema
                        </button>
                    </div>
                </form>
            </div>
        </div>
    )
}

export default MainCard;

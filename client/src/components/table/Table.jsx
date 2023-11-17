
export const Table = ({ data }) => {
    data = data || {}

    return (
        <div className="max-h-96 overflow-y-auto">
            <table className="min-w-full divide-y divide-gray-200">
                <tbody className="bg-white divide-x divide-y divide-gray-200">
                    {Object.entries(data).map(([key, value]) => (
                        <tr key={key} className="divide-x divide-gray-200">
                            <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{key}</td>
                            {Array.isArray(value) ? (
                                value.map((item, index) => (
                                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500" key={index}>
                                        {item}
                                    </td>
                                ))
                            ) : (
                                <td>{value}</td>
                            )}
                        </tr>
                    ))}
                </tbody>
            </table>
        </div>
    );
};
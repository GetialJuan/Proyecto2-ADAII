export const MatrixTable = ({ matrix }) => {
    const [head, ...tail] = matrix || [];
    return (
        <div className="max-h-96 overflow-y-auto">
            <table className="min-w-full divide-y divide-gray-200">
                <tbody className="bg-white divide-x divide-y divide-gray-200">
                    <tr>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500"> {'Periodo'} </td>
                        {head.map((cell, cellIndex) => (
                            <td key={cellIndex} className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                {cellIndex + 1}
                            </td>
                        ))}
                    </tr>
                    {tail.map((row, rowIndex) => (
                        <tr key={rowIndex}>
                            <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                {"Utpee " + (rowIndex + 1)}
                            </td>
                            {row.map((cell, cellIndex) => (
                                <td key={cellIndex} className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                    {cell}
                                </td>
                            ))}
                        </tr>
                    ))}
                </tbody>
            </table>
        </div>
    );
};
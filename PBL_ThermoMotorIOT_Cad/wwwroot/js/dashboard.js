// Configuração do gráfico
window.onload = function () {
    const chart = new CanvasJS.Chart("chartContainer", {
        theme: "light1", // Opções: "light2", "dark1", "dark2"
        animationEnabled: true,
        title: {
            text: "Total de Cadastros"
        },
        axisY: {
            interval: 5, // Define o intervalo de valores no eixo Y
            title: "Quantidade",
            includeZero: true // Garante que o eixo Y comece do zero
        },
        data: [
            {
                type: "column", // Gráfico de colunas
                dataPoints: dataPoints
            }
        ]
    });
    chart.render();
};

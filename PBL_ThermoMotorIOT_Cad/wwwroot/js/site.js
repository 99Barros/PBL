$(document).ready(function () {
    $('#btnBuscar').click(function () {
        // Obtendo os valores dos campos
        const nomeUsuario = $('#nomeUsuario').val();
        const nomeEmpresa = $('#nomeEmpresa').val();
        const nomeEstufa = $('#nomeEstufa').val();

        // Fazendo uma requisição AJAX
        $.ajax({
            url: '/Consulta/GetTabelaDados',
            type: 'GET',
            data: {
                NomeUsuario: nomeUsuario,
                nomeEmpresa: nomeEmpresa,
                nomeEstufa: nomeEstufa
            },
            success: function (data) {
                // Limpando a tabela antes de popular
                $('#resultTable thead').empty();
                $('#resultTable tbody').empty();

                if (data.length > 0) {
                    // Gerar cabeçalhos da tabela dinamicamente
                    const headers = Object.keys(data[0]); // Obtém os nomes das colunas
                    let headerRow = '<tr>';
                    headers.forEach(header => {
                        headerRow += `<th>${header}</th>`;
                    });
                    headerRow += '</tr>';
                    $('#resultTable thead').append(headerRow);

                    // Gerar linhas da tabela dinamicamente
                    data.forEach(row => {
                        let rowHtml = '<tr>';
                        headers.forEach(header => {
                            rowHtml += `<td>${row[header] || ''}</td>`;
                        });
                        rowHtml += '</tr>';
                        $('#resultTable tbody').append(rowHtml);
                    });
                } else {
                    // Nenhum dado encontrado
                    $('#resultTable tbody').append('<tr><td colspan="100%" class="text-center">Nenhum dado encontrado.</td></tr>');
                }
            },
            error: function (xhr, status, error) {
                alert("Erro ao buscar os dados: " + error);
            }
        });
    });
});

function buscaCEP() {
    var cep = document.getElementById("cep").value;
    cep = cep.replace('-', ''); // removemos o traço do CEP
    if (cep.length > 0) {
        var linkAPI = 'https://viacep.com.br/ws/' + cep + '/json/';
        $.ajax({
            url: linkAPI,
            beforeSend: function () {
                document.getElementById("logradouro").value = '...';
                document.getElementById("localidade").value = '...';
                document.getElementById("uf").value = '...';
            },
            success: function (dados) {
                if (dados.erro != undefined) // quando o CEP não existe...
                {
                    alert('CEP não localizado...');
                    document.getElementById("logradouro").value = '';
                    document.getElementById("localidade").value = '';
                    document.getElementById("uf").value = '';
                }
                else // quando o CEP existe
                {
                    document.getElementById("logradouro").value = dados.logradouro;
                    document.getElementById("localidade").value = dados.localidade;
                    document.getElementById("uf").value = dados.uf;
                    document.getElementById("numero").focus();

                }
            }
        });
    }
}
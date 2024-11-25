# Projeto Data Logger com monitoramento IoT

Este projeto desenvolve um sistema de monitoramento IoT para um dispositivo Data Logger, utilizando o micro controlador ESP32 Doit DEVKIT V1 e a plataforma FIWARE Descomplicado. O objetivo é controlar e monitorar as variáveis ambientais, como temperatura, luminosidade e umidade, dentro de faixas específicas. Quando os níveis das variáveis chegam nos limites pré-definidos, o sistema dispara uma notificação visual com um LED. 
# Descrição do projeto
Este sistema é projetado para monitorar a temperatura, umidade e luminosidade do ambiente. Com o uso do ESP32, sensores DHT11 e LDR, o sistema coleta dados ambientais e os envia ao back-end FIWARE, onde são armazenados em uma base de dados MongoDB por meio do componente STH-Comet. Um dashboard em Python permite o acompanhamento em tempo real, e notificações são geradas no front-end quando os parâmetros chegam nos níveis estabelecidos. 
# Especificações técnicas
* Microcontrolador: ESP32 Doit DEVKIT V1 

* Back-end: Plataforma FIWARE Descomplicado 

* Armazenamento: MongoDB (via STH-Comet) 

* Controle de Tempo: Time stamp gerado pelo Orion Context Broker 

* Interface de Usuário: Dashboard em Python 

* Sensores: 

   -DHT11: Sensor de Temperatura e Umidade 

   -LDR: Sensor de Luminosidade 

* Gatilhos de Alerta: 

   -Temperatura: 15 < t < 25 ºC 

   -Luminosidade: 0 < l < 30% 

   -Umidade: 30% < u < 50% 

* Sinalização Visual: LED azul no ESP32 aciona ao atingir os níveis de alerta. 

# Arquitetura do sistema 

Este sistema de monitoramento IoT é composto pelos seguintes componentes: 

* ESP32: Microcontrolador que gerencia a coleta de dados e acionamento do LED de alerta. 

* FIWARE Descomplicado: Plataforma de back-end para gerenciar e armazenar os dados em tempo real. 

* Orion Context Broker: Responsável por gerar timestamps e manter o contexto atualizado dos dados. 

* STH-Comet: Subsistema de armazenamento em MongoDB para armazenar e recuperar séries temporais dos dados dos sensores. 

* Dashboard em Python: Interface gráfica para visualização e acompanhamento dos dados coletados em tempo real. 

# Lista de materiais 

Quantidade -	Item -	Descrição 

1	ESP32 Doit DEVKIT V1	Microcontrolador 

1	LDR + Resistor de 10KOhm	Sensor de Luminosidade 

1	DHT-11	Sensor de Temperatura e Umidade 

1	Protoboard	Para montagem do circuito 

Vários	Jumpers	Conexão dos componentes 

Vários	LEDs e Resistores	Sinalização visual 

## Instalação e configuração

### Pré-requisitos:

* Python 3.x (para o dashboard) 

* MongoDB 

* FIWARE Orion Context Broker e STH-Comet 

### Configuração do ESP32: 

* Carregue o código no ESP32, configurando os sensores DHT11 e LDR para capturar dados de temperatura, umidade e luminosidade. 

* Conecte o ESP32 à rede Wi-Fi, para comunicação com o back-end FIWARE. 

* Defina as faixas de gatilhos no código do ESP32, conforme os limites desejados: 

     Temperatura: 15 < t < 25 ºC 

     Luminosidade: 0 < l < 30% 

     Umidade: 30% < u < 50% 

### Configuração do FIWARE e MongoDB 

* Inicie o Orion Context Broker para gerenciamento de contexto e geração de timestamps. 

* Configure o STH-Comet para conectar-se ao MongoDB e armazenar os dados coletados. 

* No MongoDB, crie um banco de dados e uma coleção para armazenar as séries temporais dos dados. 

### Instalação do Dashboard 

Clone o repositório deste projeto. 

Navegue até o diretório do projeto e instale as dependências:

```
pip install -r requirements.txt 

Execute o dashboard: 

python dashboard.py 
```

## Contribuição

Contribuições são bem-vindas! Por favor, faça um fork do repositório e crie uma pull request com suas sugestões. 

## License

[MIT](https://choosealicense.com/licenses/mit/)

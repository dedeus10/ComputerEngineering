/************PROJETO FINAL DA DISCIPLINA DE INTELIGENCIA ARTIFICIAL APLICADA AO PROCESSAMENTO DE SINAIS BIOMEDICOS ************/
O proposito deste trabalho era coletar sinais de Eletrocardiograma (ECG) e enferir se uma pessoa estava em atividade fisica ou repouso
Foram usados metodos de processamento de sinais, filtros, e algoritmos de Machine Learning implementados em Python
Para mais detalhes leia o artigo "Artigo_IABiomedicos.pdf" 

***PARA EXECUTAR**
Existem 2 scripts que executam o projeto.
1 - script_elgendi.sh -> Extrai informacoes dos sinais de ECG e salva em arquivos .csv
2- script_dataAnalysis.sh -> Executa os algoritmos de machine learning

**Para rodar um script é so ir em um terminal, ir ate a pasta do script e dar o comando: ./script_dataAnalysis.sh
Talvez precise de acesso root
Talvez precise dar permissão a algum arquivo: "chmod 777 arquivoTal.algExtensao"

Notas:
Ao executar o script_dataAnalysis.sh ele vai pedir o nome do paciente de teste coloque: husm (Foi usado um paciente real do husm para testar a aplicação)
Para executar os "plots" de imagem abra o scripts e remova o parametro -O

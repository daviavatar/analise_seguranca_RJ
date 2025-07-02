import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

df= pd.read_csv('BaseMunicipioMensal.csv', sep= ';')

'''#remoção de colunas obsoletas 
colunas= ['roubo_veiculo', 'furto_veiculos', 'recuperacao_veiculos']
df_filtrada=df[colunas]'''

# exercício 1 ___________________________________________________________________________

#evolução da recuperação de veículos
df_carros= df.groupby('ano')['recuperacao_veiculos'].sum().reset_index()
df_carros['ano'] = df_carros['ano'].astype(str) # troca o tipo da variaável ano para int 

#gráfico
plt.plot(df_carros['ano'],df_carros['recuperacao_veiculos'])
plt.title('\nEvolução da Recuperação de Veículos\n')
plt.xlabel('\nAno\n')
plt.ylabel('\nRecuperaação de Veículos\n')
plt.grid(True)
plt.show

# gráfico de correlação de recuperação de veículos e ROUBO 
plt.scatter(df['recuperacao_veiculos'], df['roubo_veiculo'])
plt.title('\nCorrelação de "Recuperação de Veículos" e "Roubo"\n')
plt.xlabel('\nRecuperação de Veículo\n')
plt.ylabel('\nRoubo de Veículos\n')
plt.show

# gráfico de correlação de recuperação de veículos e FURTO 
plt.scatter(df['recuperacao_veiculos'], df['furto_veiculos'])
plt.title('\nCorrelação de "Recuperação de Veículos" e "Furto"\n')
plt.xlabel('\nRecuperação de Veículo\n')
plt.ylabel('\nFurto de Veículos\n')
plt.show

# exercício 2 ___________________________________________________________________________

# lista de municipios que compoem a baixada
municipios_baix = ['Belford Roxo', 'Duque de Caxias', 'Guapimirim', 'Itaguaí', 'Japeri', 'Magé', 'Mesquita', 'Nilópolis', 'Nova Iguaçu', 'Paracambi', 'Queimados', 'São João de Meriti', 'Seropédica']

# filtra pelas colunas necessárias para a análise
df_baixada = df[(df['fmun'].isin(municipios_baix) & df['aaapai'])]

# agrupa e soma a quantidade de apreensões por município
df_baixada= df_baixada.groupby('fmun')['aaapai'].sum().reset_index()
df_baixada = df_baixada.sort_values(by='aaapai', ascending= False) #coloca em ordem decrescente

#transformando em array
dados= np.array(df_baixada['aaapai'])
q3= np.percentile(dados,75) #definindo interquartil

maior25= df_baixada.loc[df_baixada['aaapai']>= q3] # definindo a condição
maior25 = maior25.sort_values('aaapai', ascending=False) # colocando em ordem decrescente

# gráfico referente ao ponto 2 
df_baixada.plot(kind= 'barh', x = 'fmun', y= 'aaapai')
plt.title('\nAnálise de homogeniedade nos municipios\n')
plt.xlabel('\nMunicípios\n')
plt.ylabel('\nApreensões\n')
plt.show

# exercício 3 ___________________________________________________________________________

df2= pd.read_csv('BaseDP.csv', sep= ';') # importação de outra base 

#evolução dos registros de estelionato na cidade
df_estel_ano= df2.groupby('ano')['estelionato'].sum().reset_index()
df_estel_ano['ano'] = df_estel_ano['ano'].astype(str) # troca o tipo da variável ano para int 

# delegacias que compoem as 25% com mais ocorrências
df_estel= df2.groupby('cisp')['estelionato'].sum().reset_index()
dados_estel= np.array(df_estel['estelionato'])
q3= np.percentile(dados_estel,75)

maior_estel_25= df_estel.loc[df_estel['estelionato'] >= q3]
maior_estel_25= maior_estel_25.sort_values('estelionato', ascending=False)

# exercicio 4 ____________________________________________________________________________

#criação de lista dos mucinicipios da regiao de lagos
regiao_lagos= ['Araruama', 'Armação dos Búzios', 'Arraial do Cabo', 'Cabo Frio', 'Iguaba Grande', 'São Pedro da Aldeia', 'Saquarema', 'Maricá']
#criação de lista das colunas classificadas como crimes violentos
crimes_violentos = ['hom_doloso', 'lesao_corp_morte' ,'latrocinio', 'cvli', 'hom_por_interv_policial', 'letalidade_violenta', 'tentat_hom' ,'lesao_corp_dolosa', 'estupro']

# filtra pelas municipios da regiao dos lagos
df_lagos = df[(df['fmun'].isin(regiao_lagos))]

#agrupando apenas pelos crimes violentos
df_lagos= df_lagos.groupby('fmun')[crimes_violentos].sum().reset_index()

#Criando uma nova coluna 
df_lagos['Crimes Violentos'] = df_lagos[crimes_violentos].sum(axis=1)


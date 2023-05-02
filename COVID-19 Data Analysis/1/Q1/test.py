import dash
from dash import dcc
from dash import html
from dash.dependencies import Input, Output
import plotly.express as px
import pandas as pd


app = dash.Dash(__name__)
server = app.server

df = pd.read_excel('D:/CCNY/Spring 2023/CSc 47400/informative-graphics/COVID-19 Data Analysis/1/New Data/Covid_Protection_Efficacy_By_Country_New.xlsx')
vaccines_admin = df[["COUNTRY", "DATE_UPDATED", "TOTAL Population", "Population Vaccinated"]]
vaccines_admin = vaccines_admin.sort_values('DATE_UPDATED')

df_grouped = vaccines_admin.groupby([pd.Grouper(key='DATE_UPDATED', freq='M'), 'COUNTRY']).sum().reset_index()

vaccine_dict = {}

for index, row in df.iterrows():
    vaccines = str(row['VACCINES_USED']).split(',')
    for vaccine in vaccines:
        if vaccine in vaccine_dict:
            vaccine_dict[vaccine].append(row['ISO3'])
        else:
            vaccine_dict[vaccine] = [row['ISO3']]

data = []
for vaccine, iso3_list in vaccine_dict.items():
    data.append({"vaccine": vaccine, "iso3_list": iso3_list})

vaccine_df = pd.DataFrame(data)

vaccine_df = vaccine_df.explode("iso3_list")

fig1 = px.histogram(df_grouped, x='Population Vaccinated', y='DATE_UPDATED', color='COUNTRY', 
                   histfunc='sum', nbins=len(df_grouped['DATE_UPDATED'].unique()),
                   labels={'Population Vaccinated': 'Population Vaccinated'},
                   color_discrete_sequence=px.colors.qualitative.Set3_r)

fig1.update_layout(bargap=0)
fig1.update_layout(
    bargap=0,
    yaxis_title='Month'
)
fig1.update_layout(
    bargap=0,
    xaxis_title='Population Vaccinated'
)

fig2 = px.choropleth(vaccine_df, 
                    locations="iso3_list", 
                    locationmode="ISO-3",
                    color="vaccine",
                    projection="natural earth",
                    title="Vaccine usage by country",
                    height=1000,
                    width=1700,
                   )

bubble_df =df
vaccine_counts = df.groupby('ISO3')['VACCINES_USED'].nunique().reset_index()
vaccine_counts.columns = ['iso3_list', 'NUMBER_VACCINES_TYPES_USED']

bubble_df = bubble_df.merge(vaccine_counts, on='iso3_list', how='left')

bubble_df['Number of Vaccine Types Used'] = bubble_df['NUMBER_VACCINES_TYPES_USED']

bubble_chart = px.scatter(bubble_df, x='iso3_list', y='NUMBER_VACCINES_TYPES_USED', 
                          size='NUMBER_VACCINES_TYPES_USED', color='vaccine',
                          hover_name='COUNTRY', labels={'ISO3': 'Country Code',
                                                         'NUMBER_VACCINES_TYPES_USED': 'Number of Vaccine Types Used'})


vaccine_efficacy = df[["COUNTRY", "DATE_UPDATED", "% Population vaccinated", "% People Protected for ORGINAL SEVERE"]]

fig3 = px.scatter(vaccine_efficacy, 
                  x='% Population vaccinated', 
                  y='% People Protected for ORGINAL SEVERE', 
                  color='COUNTRY',
                  size='% People Protected for ORGINAL SEVERE', 
                  labels={'% Population vaccinated': '% Population vaccinated', '% People Protected for ORGINAL SEVERE': 'Percent of People Protected from severe infection'},
                  color_discrete_sequence=px.colors.qualitative.Set3_r) 

vaccine_efficacy_2 = df[["COUNTRY", "DATE_UPDATED", "% Population vaccinated", "% People Protected for ORGINAL INFECTION"]]

fig4 = px.scatter(vaccine_efficacy_2, 
                  x='% Population vaccinated', 
                  y='% People Protected for ORGINAL INFECTION', 
                  color='COUNTRY',
                  size='% People Protected for ORGINAL INFECTION', 
                  labels={'% Population vaccinated': '% Population vaccinated', '% People Protected for ORGINAL INFECTION': '% People Protected for original varient infection'},
                  color_discrete_sequence=px.colors.qualitative.Set3_r) 
fig4.update_yaxes(range=[0,120])


vaccine_efficacy_3 = df[["COUNTRY", "DATE_UPDATED", "% Population vaccinated", "% People Protected for OMICRON SEVERE"]]

fig5 = px.scatter(vaccine_efficacy_3, 
                  x='% Population vaccinated', 
                  y='% People Protected for OMICRON SEVERE', 
                  color='COUNTRY',
                  size='% People Protected for OMICRON SEVERE', 
                  labels={'% Population vaccinated': '% Population vaccinated', '% People Protected for OMICRON SEVERE': '% People Protected for OMICRON SEVERE'},
                  color_discrete_sequence=px.colors.qualitative.Set3_r) 

fig5.update_yaxes(range=[0,120])

vaccine_efficacy_4 = df[["COUNTRY", "DATE_UPDATED", "% Population vaccinated", "% People Protected for OMICRON INFECTION"]]

fig6 = px.scatter(vaccine_efficacy_4, 
                  x='% Population vaccinated', 
                  y='% People Protected for OMICRON INFECTION', 
                  color='COUNTRY',
                  size='% People Protected for OMICRON INFECTION', 
                  labels={'% Population vaccinated': '% Population vaccinated', '% People Protected for OMICRON INFECTION': '% People Protected for OMICRON INFECTION'},
                  color_discrete_sequence=px.colors.qualitative.Set3_r) 
fig6.update_yaxes(range=[0,120])

vaccine_efficacy_5 = df[["COUNTRY", "DATE_UPDATED", "TOTAL Population", "% People Protected for OMICRON SEVERE", "% People Protected for OMICRON INFECTION"]]

fig7 = px.scatter(vaccine_efficacy_5, 
                  x='% People Protected for OMICRON SEVERE', 
                  y='% People Protected for OMICRON INFECTION', 
                  color='COUNTRY',
                  size='TOTAL Population', 
                  labels={'% People Protected for OMICRON SEVERE': '% People Protected for OMICRON SEVERE', '% People Protected for OMICRON INFECTION': '% People Protected for OMICRON INFECTION'},
                  color_discrete_sequence=px.colors.qualitative.Set3_r,
                  size_max=60,) 
fig7.update_yaxes(range=[0,100])
fig7.update_xaxes(range=[0,100])

vaccine_efficacy_6 = df[["COUNTRY", "DATE_UPDATED", "TOTAL Population", "% People Protected for ORGINAL INFECTION", "% People Protected for ORGINAL SEVERE"]]

fig8 = px.scatter(vaccine_efficacy_6, 
                  x='% People Protected for ORGINAL SEVERE', 
                  y='% People Protected for ORGINAL INFECTION', 
                  color='COUNTRY',
                  size='TOTAL Population', 
                  labels={'% People Protected for ORGINAL SEVERE': '% People Protected for ORGINAL SEVERE', '% People Protected for ORGINAL INFECTION': '% People Protected for ORGINAL INFECTION'},
                  color_discrete_sequence=px.colors.qualitative.Set3_r,size_max=60,) 
fig8.update_yaxes(range=[0,100])
fig8.update_xaxes(range=[0,100])

app.layout = html.Div([
    
    dcc.Tabs(id='tabs', value='tab1', children=[
        dcc.Tab(label='Vaccine usage by country', value='tab1', children=[
            html.P('The graphic below shows what type of vaccines are used by each country.', style={'textAlign': 'center'}),
            html.P('There is overlapping data as there can be multiple countries using the same vaccine.', style={'textAlign': 'center'}),
            html.P('Click on the legend to see enable and disable the country. Best if all of them unselected and then clicked on one by one to avoid overlapping data. ', style={'textAlign': 'center'}),
            dcc.Graph(id='vaccine-usage-map', figure=fig2),
            dcc.Graph(id='scatter-trace', figure=bubble_chart),
        ]),
        dcc.Tab(label='Total population vaccinated by Month and Country', value='tab2', children=[
            dcc.Graph(id='vaccinations-graph', figure=fig1),
            dcc.Dropdown(
                id='x-axis-dropdown',
                options=[
                    {'label': 'Total Population', 'value': 'TOTAL Population'},
                    {'label': 'Population Vaccinated', 'value': 'Population Vaccinated'}
                ],
                value='Population Vaccinated'
            ),
            html.P('The chart below shows the rapid increase in vaccinations from July 2021 to October 2022.', style={'textAlign': 'center'}),
            html.P('The data shows that there was a huge spike in population vaccinated around October 2022.', style={'textAlign': 'center'}),
        ]),
        
        dcc.Tab(label='% population vs people infected', value='tab3', children= [
            html.H1('Original varient', style={'textAlign': 'center'}),
            dcc.Graph(id='scatter-plot', figure=fig3),
            html.P('Percent of people protected from severe infection the original varient and the percent of the population vaccinated.', style={'textAlign': 'center'}),
            html.P('This graphic shows that as the increase in the percent of population vaccinated increases the number of people protected from the original varient was directly associated to it.', style={'textAlign': 'center'}),
            html.P('The line trended upwards linearly.', style={'textAlign': 'center'}),
            dcc.Graph(id='scatter-plot-2', figure=fig4),
            html.P('Looking at the percent of people protected from the original varient along with the population of people infected there was not much of a difference as compared to the severe infection data.', style={'textAlign': 'center'}),
            html.H1('Omicron varient', style={'textAlign': 'center'}),
            dcc.Graph(id='scatter-plot-3', figure=fig5),
            dcc.Graph(id='scatter-plot-4', figure=fig6),
            html.P('For the omicron varient it is evident that the slope of the trendline for the protection from normal infection is lower compared to the original varient.', style={'textAlign': 'center'}),
            html.P('Protection againt severe infection is higher and very similar to the original varient.', style={'textAlign': 'center'}),
            html.P('It can be concluded that the vaccination used for the original varient is somewhat effective but these numbers are not accurate because of variables such as:', style={'textAlign': 'center'}),
            html.Ul([
                html.Li('1. Number of each vaccines used for each country is not really known'),
                html.Li('2. Are the people already immune by themselves and the vaccines are just additional')
            ], style={'textAlign': 'center'}),
            
        ]),
        dcc.Tab(label='- > further analysis', value='tab4', children= [
            dcc.Graph(id='scatter-plot-5', figure=fig7),
            dcc.Graph(id='scatter-plot-6', figure=fig8),
            html.P('Analyzing these two graphs you can see that the original varient had more protection because the plotted points extend further in the x-axis.', style={'textAlign': 'center'}),
            html.P('The omicron has a flatter slope and that means there are more people protected from the omicron severe as compared to normal infection.', style={'textAlign': 'center'}),
            html.P('That just means deaths should not be that much higher if data was given on the deaths.', style={'textAlign': 'center'}),
            html.P('Comparing that to the original variant there was more of a correlation but it still trended towards the severe infection', style={'textAlign': 'center'}),
            html.P('Concluding that the vaccines used did a pretty good job protecting from severe hospitalizations and for normal infections it did not do a good job.', style={'textAlign': 'center'}),
        ]),
        dcc.Tab(label='', value='tab5', children= [
        ]),
    ]),
])
## html.P('', style={'textAlign': 'center'}),
@app.callback(
    Output('vaccinations-graph', 'figure'),
    [Input('x-axis-dropdown', 'value')]
)

def update_figure(xaxis_column_name):
    fig = px.histogram(df_grouped, x=xaxis_column_name, y='DATE_UPDATED', color='COUNTRY', 
                   histfunc='sum', nbins=len(df_grouped['DATE_UPDATED'].unique()),
                   labels={xaxis_column_name: xaxis_column_name, 'Population Vaccinated': 'Population Vaccinated'},
                   title='',
                   color_discrete_sequence=px.colors.qualitative.Set3_r)
    fig.update_layout(bargap=0)
    fig.update_layout(
        bargap=0,
        yaxis_title='Month'
    )
    fig.update_layout(
        bargap=0,
        xaxis_title=xaxis_column_name
    )
    return fig

if __name__ == '__main__':
    app.run_server(debug=True, port=8000)

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


fig9 = px.treemap(df, 
                 path=['COUNTRY'], 
                 values='% SUCEPTIBLE for  BREAKTHROUGH  ORGINAL SEVERE', 
                 color='COUNTRY',
                 color_continuous_scale= px.colors.qualitative.Set3_r,
                 title='% SUCEPTIBLE for  BREAKTHROUGH  ORGINAL SEVERE',
                 hover_data={'% SUCEPTIBLE for  BREAKTHROUGH  ORGINAL SEVERE': ':.2f'})

fig10_1 = df.groupby('WHO_REGION')['% SUCEPTIBLE for  BREAKTHROUGH  ORGINAL SEVERE'].mean().reset_index()

fig10 = px.treemap(fig10_1, 
                 path=['WHO_REGION'], 
                 values='% SUCEPTIBLE for  BREAKTHROUGH  ORGINAL SEVERE', 
                 color='WHO_REGION',
                 color_continuous_scale= px.colors.qualitative.Set3_r,
                 title='% SUCEPTIBLE for  BREAKTHROUGH  ORGINAL SEVERE',
                 hover_data={'% SUCEPTIBLE for  BREAKTHROUGH  ORGINAL SEVERE': ':.2f'})

fig11 = px.treemap(df, 
                 path=['COUNTRY'], 
                 values='% SUCEPTIBLE for  BREAKTHROUGH ORIGINAL  INFECTION', 
                 color='COUNTRY',
                 color_continuous_scale= px.colors.qualitative.Set3_r,
                 title='% SUCEPTIBLE for  BREAKTHROUGH ORIGINAL  INFECTION',
                 hover_data={'% SUCEPTIBLE for  BREAKTHROUGH ORIGINAL  INFECTION': ':.2f'})

fig12_1 = df.groupby('WHO_REGION')['% SUCEPTIBLE for  BREAKTHROUGH ORIGINAL  INFECTION'].mean().reset_index()

fig12 = px.treemap(fig12_1, 
                 path=['WHO_REGION'], 
                 values='% SUCEPTIBLE for  BREAKTHROUGH ORIGINAL  INFECTION', 
                 color='WHO_REGION',
                 color_continuous_scale= px.colors.qualitative.Set3_r,
                 title='% SUCEPTIBLE for  BREAKTHROUGH ORIGINAL  INFECTION',
                 hover_data={'% SUCEPTIBLE for  BREAKTHROUGH ORIGINAL  INFECTION': ':.2f'})

## omicron 
fig13 = px.treemap(df, 
                 path=['COUNTRY'], 
                 values='% SUCEPTIBLE for  BREAKTHROUGH OMICRON SEVERE', 
                 color='COUNTRY',
                 color_continuous_scale= px.colors.qualitative.Set3_r,
                 title='% SUCEPTIBLE for  BREAKTHROUGH OMICRON SEVERE',
                 hover_data={'% SUCEPTIBLE for  BREAKTHROUGH OMICRON SEVERE': ':.2f'})

fig14_1 = df.groupby('WHO_REGION')['% SUCEPTIBLE for  BREAKTHROUGH OMICRON SEVERE'].mean().reset_index()

fig14 = px.treemap(fig14_1, 
                 path=['WHO_REGION'], 
                 values='% SUCEPTIBLE for  BREAKTHROUGH OMICRON SEVERE', 
                 color='WHO_REGION',
                 color_continuous_scale= px.colors.qualitative.Set3_r,
                 title='% SUCEPTIBLE for  BREAKTHROUGH OMICRON SEVERE',
                 hover_data={'% SUCEPTIBLE for  BREAKTHROUGH OMICRON SEVERE': ':.2f'})

fig15 = px.treemap(df, 
                 path=['COUNTRY'], 
                 values='% SUCEPTIBLE for  BREAKTHROUGH OMICRON INFECTION', 
                 color='COUNTRY',
                 color_continuous_scale= px.colors.qualitative.Set3_r,
                 title='% SUCEPTIBLE for  BREAKTHROUGH OMICRON INFECTION',
                 hover_data={'% SUCEPTIBLE for  BREAKTHROUGH OMICRON INFECTION': ':.2f'})

fig16_1 = df.groupby('WHO_REGION')['% SUCEPTIBLE for  BREAKTHROUGH OMICRON INFECTION'].mean().reset_index()

fig16 = px.treemap(fig16_1, 
                 path=['WHO_REGION'], 
                 values='% SUCEPTIBLE for  BREAKTHROUGH OMICRON INFECTION', 
                 color='WHO_REGION',
                 color_continuous_scale= px.colors.qualitative.Set3_r,
                 title='% SUCEPTIBLE for  BREAKTHROUGH OMICRON INFECTION',
                 hover_data={'% SUCEPTIBLE for  BREAKTHROUGH OMICRON INFECTION': ':.2f'})
fig17_1 = df.groupby('WHO_REGION')["% SUCEPTIBLE for  BREAKTHROUGH  ORGINAL SEVERE", 
                                      "% SUCEPTIBLE for  BREAKTHROUGH ORIGINAL  INFECTION",
                                      "% SUCEPTIBLE for  BREAKTHROUGH OMICRON SEVERE",
                                      "% SUCEPTIBLE for  BREAKTHROUGH OMICRON INFECTION"].mean().reset_index()
fig17 = px.bar(fig17_1, x="WHO_REGION", y=["% SUCEPTIBLE for  BREAKTHROUGH  ORGINAL SEVERE", 
                                      "% SUCEPTIBLE for  BREAKTHROUGH ORIGINAL  INFECTION",
                                      "% SUCEPTIBLE for  BREAKTHROUGH OMICRON SEVERE",
                                      "% SUCEPTIBLE for  BREAKTHROUGH OMICRON INFECTION"],
             barmode="group",
             title="Percentage breakthrough infection",
             labels={"value": "Percentage"},
             color_discrete_sequence=px.colors.qualitative.Set3)

app.layout = html.Div([
    
    dcc.Tabs(id='tabs', value='tab1', children=[
        dcc.Tab(label='Data summary', value='tab1', children= [
            html.P('In this story I used the dataset that was contains data on countries that reported data for COVID-19 vaccination and infection rates.', style={'textAlign': 'center'}),
            html.P('The data includes:', style={'textAlign': 'center'}),
            html.Ul([
                html.Li('COUNTRY - country that entered data'),
                html.Li('ISO3 - used to identify the country'),
                html.Li('WHO_REGION - categorizes many countries into a place '),
                html.Li('DATE_UPDATED - date that the data was entered'),
                html.Li('VACCINES_USED - vaccines used by each country during time of entry'),
                html.Li('NUMBER_VACCINES_TYPES_USED - number of different vaccines used'),
                html.Li('Protection against ORIGINAL Var- SEVERE, % average - average protection against the original variant from severe infection'),
                html.Li('Protection against ORIGINAL Var- INFECTION, % average - average protection against the original variant from normal infection'),
                html.Li('Protection against LATEST var BA1.n SEVERE, % average - average protection against the Omicron variant from severe infection'),
                html.Li('Protection against LATEST var BA1.n INFECTION, % average - average protection against the Omicron variant from normal infection'),
                html.Li('TOTAL Population - total population of the country at the time of entry'),
                html.Li('Population Vaccinated - population of people vaccinated at time of entry'),
                html.Li('% Population vaccinated - Population Vaccinated / TOTAL Population'),
                html.Li('% People Protected for ORGINAL SEVERE - Protection against ORIGINAL Var- SEVERE, % average / Population Vaccinated'),
                html.Li('% People Protected for ORGINAL INFECTION - Protection against ORIGINAL Var- INFECTION, % average / Population Vaccinated'),
                html.Li('% People Protected for OMICRON SEVERE - Protection against LATEST var BA1.n SEVERE, % average / Population Vaccinated'),
                html.Li('% People Protected for OMICRON INFECTION - Protection against LATEST var BA1.n INFECTION, % average / Population Vaccinated'),
                html.Li('% SUCEPTIBLE for  BREAKTHROUGH  ORGINAL SEVERE - (Population Vaccinated - % People Protected for ORGINAL SEVERE'), 
                html.Li('% SUCEPTIBLE for  BREAKTHROUGH ORIGINAL  INFECTION - (Population Vaccinated - % People Protected for ORGINAL INFECTION)'), 
                html.Li('% SUCEPTIBLE for  BREAKTHROUGH OMICRON SEVERE - (Population Vaccinated - % People Protected for OMICRON SEVERE)'), 
                html.Li('% SUCEPTIBLE for  BREAKTHROUGH OMICRON INFECTION - (Population Vaccinated - % People Protected for OMICRON INFECTION)'), 
                html.Li('% Population NOT VACCINATED - (100 - Population Vaccinated)'), 

            ]),
            html.P('With these data points we can try to determine the trends of the data to give a somewhat of an explanation for vaccine efficacy.', style={'textAlign': 'center'}),
            html.P('The following charts and graphs will analyze the data to tell a story on vaccine efficacy and trends.', style={'textAlign': 'center'}),
            html.P('', style={'textAlign': 'center'}),
        ]),
        dcc.Tab(label='Vaccine usage by country', value='tab2', children=[
            html.P('The graphic below shows what type of vaccines are used by each country.', style={'textAlign': 'center'}),
            html.P('There is overlapping data as there can be multiple countries using the same vaccine.', style={'textAlign': 'center'}),
            html.P('Click on the legend to see enable and disable the country. Best if all of them unselected and then clicked on one by one to avoid overlapping data. ', style={'textAlign': 'center'}),
            dcc.Graph(id='vaccine-usage-map', figure=fig2),
        ]),
        dcc.Tab(label='Total population vaccinated by Month and Country', value='tab3', children=[
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
        
        dcc.Tab(label='% population vs people infected', value='tab4', children= [
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
            html.P('For the omicron varient it is evident that the slope of the trend line for the protection from normal infection is lower compared to the original varient.', style={'textAlign': 'center'}),
            html.P('Protection against severe infection is higher and very similar to the original varient.', style={'textAlign': 'center'}),
            html.P('It can be concluded that the vaccination used for the original varient is somewhat effective but these numbers are not accurate because of variables such as:', style={'textAlign': 'center'}),
            html.Ul([
                html.Li('1. Number of each vaccines used for each country is not really known'),
                html.Li('2. Are the people already immune by themselves and the vaccines are just additional')
            ], style={'textAlign': 'center'}),
            
        ]),
        dcc.Tab(label='- > further analysis', value='tab5', children= [
            dcc.Graph(id='scatter-plot-5', figure=fig7),
            dcc.Graph(id='scatter-plot-6', figure=fig8),
            html.P('Analyzing these two graphs you can see that the original varient had more protection because the plotted points extend further in the x-axis.', style={'textAlign': 'center'}),
            html.P('The omicron has a flatter slope and that means there are more people protected from the omicron severe as compared to normal infection.', style={'textAlign': 'center'}),
            html.P('That just means deaths should not be that much higher if data was given on the deaths.', style={'textAlign': 'center'}),
            html.P('Comparing that to the original variant there was more of a correlation but it still trended towards the severe infection', style={'textAlign': 'center'}),
            html.P('Concluding that the vaccines used did a pretty good job protecting from severe hospitalizations and for normal infections it did not do a good job.', style={'textAlign': 'center'}),
        ]),
        dcc.Tab(label='tree maps', value='tab6', children= [
            html.H1('Original variant', style={'textAlign': 'center'}),
            html.H3('Original', style={'textAlign': 'center'}),
            dcc.Graph(id='scatter-plot-9', figure=fig11),
            dcc.Graph(id='scatter-plot-10', figure=fig12),
            html.P('', style={'textAlign': 'center'}),

            html.H3('Severe', style={'textAlign': 'center'}),
            dcc.Graph(id='scatter-plot-7', figure=fig9),
            html.P('This tree map shows that in general the countries have around the same breakthrough infections for the original variant where there are some outliers which can depend on how the country runs economically and how often people interact.', style={'textAlign': 'center'}),
            dcc.Graph(id='scatter-plot-8', figure=fig10),
            html.P('The same but data as the graph above but now it is grouped by WHO_REGION.', style={'textAlign': 'center'}),
            html.P('Others is specifically Liechtenstein, which is not part of the WHO so their data is to themselves.', style={'textAlign': 'center'}),
            html.P('This shows that SEARO has twice as many breakthrough infections as compared to AFRO. There can be many reasons like economical and social practices that can play into the reason why.', style={'textAlign': 'center'}),
            
            html.H1('Omicron', style={'textAlign': 'center'}),
            html.P('Now analyzing the Omicron variant to see if breakthrough infections would be the same from country to country. Given analysis from before it can be shown that Omicron variant has higher rates of infection because of the bubble charts data.', style={'textAlign': 'center'}),
            html.H3('Severe', style={'textAlign': 'center'}),
            dcc.Graph(id='scatter-plot-11', figure=fig13),
            dcc.Graph(id='scatter-plot-12', figure=fig14),
            dcc.Graph(id='scatter-plot-13', figure=fig15),
            dcc.Graph(id='scatter-plot-14', figure=fig16),
            html.P('The data here is similar in size and idea but the numbers are not well shown as the data when hovered shows that Omicron has way higher infection breakthrough as the original variant. ', style={'textAlign': 'center'}),
            html.P('To show this better there will be a different graphic that will portrait this information. ', style={'textAlign': 'center'}),
            dcc.Graph(id='scatter-plot-15', figure=fig17),
            html.P('This graph shows uniformly that for the original variant severe infection was low on the breakthrough, meaning even if vaccinated there was a low chance of getting sick from the virus.', style={'textAlign': 'center'}),
            html.P('Then it was infection from original variant and then same for omicron as the severe is lower than the normal infection without hospitalization.', style={'textAlign': 'center'}),
            html.P('It can be seen that the original variant across all WHO nations was around 2 times as less likely to be infectious as compared to the Omicron variant. ', style={'textAlign': 'center'}),
        ]),
        dcc.Tab(label='Conclusion', value='tab7', children= [
            html.P('The data shows that the vaccines used were effective for the original variant but when it came to the Omicron variant it did not perform as well mean countries needed to take further action such as social distancing and other preventative measure to ensure safety ', style={'textAlign': 'center'}),
            html.H3('Future improvements', style={'textAlign': 'center'}),
            html.P('What can be done is add in death of each country at the time of the data entry because mortality rates are important as well as the infection. What we want to prevent with the vaccination is not infection but death. So in the future I can maybe cross reference datasets that has death of people in each country and that would give a better idea of efficacy. It is hard to track data like exactly what vaccine was used and percent of people fully vaccinated along with people partially vaccinated. That data was not collected if it was collected it was not publicly available but if that data was posted it would have made a more accurate analysis.', style={'textAlign': 'center'}),
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

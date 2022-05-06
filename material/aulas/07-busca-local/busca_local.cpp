#include<iostream>
#include<vector>
#include<algorithm>
#include <random>

using namespace std;

struct item {
    int id;
    double peso;
    double valor;
};

bool my_compare(item a, item b){
    return a.peso > b.peso;
}

int main() {
    default_random_engine generator(10);
    uniform_real_distribution<double> distribution(0.0, 1.0);
    
    int n = 0;
    int W = 0;
    
    vector<item> mochila;
    vector<item> items;
    
    vector<item> melhor_mochila;
    
    cin >> n >> W;
    items.reserve(n);
    double peso, valor;
    
    for(int i = 0; i < n; i++){
        cin >> peso;
        cin >> valor;
        items.push_back({i, peso, valor});
    }
    
    peso = 0;
    valor = 0;
    int valores_mochila = 0;
    int valores_melhor_mochila = 0;
    
    for(int i = 0; i < 1000; i++){
        mochila.clear();
        for(auto& el : items){
            double prob = distribution(generator);
            if(el.peso + peso <= W and prob <= 0.5){
                mochila.push_back(el);
                peso += el.peso;
                valor += el.valor;
            }
            valores_mochila += mochila[i].valor;
        }

        sort(mochila.begin(), mochila.end(), my_compare);
        
        if (valores_mochila > valores_melhor_mochila){
            melhor_mochila = mochila;
        }
        
        peso = 0;
        valor = 0;
        valores_mochila = 0;
        items.clear();
        // cout << peso << " " << valor << endl;
    }

    int soma_melhor_mochilas = 0;
    for(auto& el: melhor_mochila){
        soma_melhor_mochilas += el.valor;
    }

    cout << soma_melhor_mochilas << endl;

    return 0;
}
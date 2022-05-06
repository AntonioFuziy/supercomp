#include<iostream>
#include<algorithm>
#include<vector>
#include<random>
using namespace std;

struct item {
    int id;
    double peso;
    double valor;
};

struct solucoes {
    double peso;
    double valor;
};

bool comparison_function(item a, item b);
bool compare(int a, int b);

int main() {
    int N;
    int W;

    cin >> N >> W;

    default_random_engine generator;
    generator.seed(10);
    uniform_real_distribution<double> distribution(0.0, 1.0);

    vector<int> resposta;

    vector<item> v(N);
    int id = 0;

    for(int i = 0; i < N; i++) {
        v[id].id = id;
        cin >> v[id].peso >> v[id].valor;
        id++;
    }

    double maxPeso, maxValor;

    maxPeso = 0.0;
    maxValor = 0.0;

    for(int iter = 0;  iter < 10; iter++) {
        vector<item> mochila;
        double peso, valor, result;

        peso = 0;
        valor = 0;

        for (int i = 0; i < N; i++) {
            result = distribution(generator);

            if(result > 0.5 && peso + v[i].peso <= W) {
                mochila.push_back(v[i]);
                peso += v[i].peso;
                valor += v[i].valor;
            }
        }

        cout << peso << " " << valor << endl;

        if(peso > maxPeso && valor > maxValor) {
            maxPeso = peso;
            maxValor = valor;
        }
    }

    cout << endl << "Melhor solução:" << endl << maxPeso << " " << maxValor << endl;


}

bool comparison_function(item a, item b) {
    return a.valor > b.valor;
}

bool compare(int a, int b) {
    return b > a;
}
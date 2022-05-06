#include <iostream>
#include <vector>

using namespace std;

struct item {
  int id;
  double peso;
  double valor;
};

int recursao_mochila(vector<item> items, int w, int i){
  int in = 0;
  int out = 0;
  if(i < int(items.size())){
    if(w - items[i].peso >= 0){
      in = items[i].valor + recursao_mochila(items, w-items[i].peso, i+1);
    } 
    out = recursao_mochila(items, w, i+1);
  } else {
    if(w - items[i].peso >= 0){
      return items[i].valor;
    } else {
      return 0;
    }
  }
  return max(in, out);
}

int main(){
  int n;
  int w;
  vector<item> items;

  cin >> n >> w;

  items.reserve(n);
  double peso; 
  double valor;
  
  for(int i = 0; i < n; i++){
    cin >> peso;
    cin >> valor;
    items.push_back({i, peso, valor});
  }

  int i = 0;
  int max_mochila = 0;
  
  max_mochila = recursao_mochila(items, w, i);
  
  cout << max_mochila << endl;

  return 0;
}
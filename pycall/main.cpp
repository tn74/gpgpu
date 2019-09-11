#include <iostream>
#include <string>
#include <fstream>

int main() {
    std::cout << "Hello, World!" << std::endl;
    const int SIZE = 50;
    struct Records {
        std::string firstname;
        std::string secondname;
        float test1mark;
        float midtestmark;
        float annualmark;
    }record[SIZE]; 
    record[0].firstname = "Trishul";
    std::ifstream in("Data.txt");

    if (!in){
        std::cerr << "File can't be opened! " <<std::endl;
        system("PAUSE");
        exit(1);
    }
    for (int i=0; i < SIZE; i++){
        in >> record[i].firstname >> record[i].secondname 
        >>record[i].test1mark >> record[i].midtestmark >> record[i].annualmark ;
    }
    for (int i=0; i < SIZE; i++){
        std::cout << record[i].firstname << " " << record[i].secondname << " " 
        << record[i].test1mark << " " << record[i].midtestmark << " " 
        << record[i].annualmark << " " 
        << record[i].test1mark + record[i].midtestmark << std::endl;
    }
}

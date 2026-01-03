#include <cstring>
#include <cstdlib>

// Прототипы функций из ассемблерного ядра
extern "C" void print_string(const char* str);
extern "C" char get_char();
extern "C" void new_line();

// Функция разбора числа из строки
int parse_number(const char* str, int& pos) {
    int result = 0;
    while (str[pos] >= '0' && str[pos] <= '9') {
        result = result * 10 + (str[pos] - '0');
        pos++;
    }
    return result;
}

// Калькулятор: принимает строку вида "2+3"
void calculator(const char* input) {
    int pos = 0;
    int left = parse_number(input, pos);

    char op = input[pos];
    pos++;

    int right = parse_number(input + pos, pos);

    int result = 0;
    switch (op) {
        case '+': result = left + right; break;
        case '-': result = left - right; break;
        case '*': result = left * right; break;
        case '/': 
            if (right != 0) result = left / right;
            else {
                print_string("Error: division by zero");
                return;
            }
            break;
        default:
            print_string("Error: unsupported operator");
            return;
    }

    // Выводим результат
    char buffer[16];
    itoa(result, buffer, 10);  // Преобразование числа в строку
    print_string(buffer);
    new_line();
}

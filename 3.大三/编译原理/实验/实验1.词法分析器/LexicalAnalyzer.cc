#include <iostream>
#include <fstream>  //用于读写文件
#include <cctype>   //C中的ctype.h

using namespace std;

string keyword[] = {"int","double","float","for","printf"};
string pathin, pathout; //保存文件io路径

ifstream fin;   //创建读取流对象fin
ofstream fout;  //创建输出流对象fout

int LexAna()
{
    cout<<"请输入需要词法分析的文件名：";
    cin>>pathin;
    cout<<"请为词法分析后的文件起名：";
    cin>>pathout;
    cout<<endl<<"正在词法分析中，请稍后..."<<endl;

    fin.open(pathin,ios_base::in); //以只读方式打开文件
    if(!fin.is_open())
    {
        cout<<"打开"<<pathin<<"失败,请检查路径是否有误"<<endl;
        return -1; //打开文件有误，返回值为-1
    }
    fout.open(pathout,ios_base::out|ios_base::trunc); //以只写方式打开文件,如果文件已存在，则清零后写入
    if(!fout.is_open())
    {
        cout<<"打开"<<pathout<<"失败,请检查路径是否有误"<<endl;
        return -1; //打开文件有误，返回值为-1
    }

    int lexErr = 0; //词法分析错误代码
    char ch;
    string token;

    while (fin)
    {
        if(!fin.get(ch))
        {
            break;
        }   //如果获取不到字符就跳出

        while(' '==ch||'\n'==ch||'\t'==ch)
        {
            if(!fin.get(ch))
            {
                break;
            }   //解决文件末尾空白字符问题
        }   //忽略掉所有空白字符

        if ('_'==ch||isalpha(ch))   //[_A-Za-z]([0-9]|[_A-Za-z])*//判断是否为字母或下划线'_'
        {
            token = "";
            token += ch;
            fin.get(ch);

            while('_'==ch||isalnum(ch))  //判断是否为字母或数字或下划线'_'
            {
                token += ch;
                fin.get(ch);
            }

            int a = 0;
            int b = 0;
            for(string i : keyword)
            {
                a++;    //记录字符串数组元素的个数
                if(token.compare(i)==0) //两字符串相等则返回0
                {
                    fout<<"<"<<token<<","<<token<<">"<<endl;
                    b = a;    //记录匹配的keyword字典的位置
                }
            }
            if(0==b)
            {
                fout<<"<"<<"Id"<<","<<token<<">"<<endl;
            }
        }

        else if(isdigit(ch))    //[0-9]+(.[0-9]+)?([Ee][+-]?[0-9]+)?
        {
            token = "";
            token += ch;
            fin.get(ch);
            while(isdigit(ch))
            {
                token += ch;
                fin.get(ch);
            }
            if('.'==ch)
            {
                token += ch;
                fin.get(ch);
                if(!isdigit(ch))
                {
                    cout<<endl<<"小数点后不是数字，词法错误，终止分析！"<<endl;
                    fout<<"小数点后不是数字，词法错误，终止分析！"<<endl;
                    return 1;
                }
                while(isdigit(ch))
                {
                    token += ch;
                    fin.get(ch);
                }
            }
            if('E'==ch||'e'==ch)
            {
                token += ch;
                fin.get(ch);
                if('+'==ch||'-'==ch)
                {
                    token += ch;
                    fin.get(ch);
                }
                if(!isdigit(ch))
                {
                    cout<<endl<<"科学记数法部分词法错误，终止分析！"<<endl;
                    fout<<"科学记数法部分词法错误词法错误，终止分析！"<<endl;
                    return 2;
                }
                while(isdigit(ch))
                {
                    token += ch;
                    fin.get(ch);
                }
                if(!isdigit(ch) && ';'!=ch)
                {
                    cout<<endl<<"科学记数法部分词法错误，终止分析！"<<endl;
                    fout<<"科学记数法部分词法错误，终止分析！"<<endl;
                    return 2;
                }
            }
            fout<<"<"<<"Num"<<","<<token<<">"<<endl;
        }

        if ('+'==ch||'-'==ch||'*'==ch||
            '/'==ch||'('==ch||')'==ch||
            '{'==ch||'}'==ch||';'==ch||
            ','==ch||'<'==ch||'>'==ch||
            '='==ch||'!'==ch)  //符号
        {
            token = "";
            token += ch;
            fout<<"<"<<token<<","<<token<<">"<<endl;
        }
    }

    fin.close();    //关闭对象到文件的连接
    fin.clear();    //清理/重置fin对象
    fout.close();
    fout.clear();
    cout<<endl<<"词法分析结束，请打开文件\""<<pathout<<"\"查看词法分析结果。"<<endl;
    cin.get();
    cin.get();

    return lexErr;
}

int main()
{
    cout<<"编译原理 实验一 词法分析器"<<endl;
    cout<<"组长：王靖伟"<<endl;
    cout<<"组员：沈宇帆 康振山 管立洋"<<endl;
    cout<<"软件工程 1201班"<<endl<<endl;

    int Err;
    Err = LexAna();
    return Err;
}

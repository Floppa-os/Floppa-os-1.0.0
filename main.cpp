#include <QApplication>
#include <QWidget>
#include <QHBoxLayout>
#include <QListView>
#include <QTreeView>
#include <QFileSystemModel>
#include <QDir>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    // Основное окно
    QWidget window;
    window.setWindowTitle("Простой проводник");
    window.resize(800, 600);

    // Горизонтальный макет для двух панелей
    QHBoxLayout *layout = new QHBoxLayout(&window);

    // Представление в виде списка
    QListView *listView = new QListView();
    listView->setWindowTitle("Список");

    // Представление в виде дерева
    QTreeView *treeView = new QTreeView();
    treeView->setWindowTitle("Дерево");

    // Добавляем виджеты в макет
    layout->addWidget(listView, 1);  // 1 — коэффициент растяжения
    layout->addWidget(treeView, 2);  // дерево займёт больше места

    // Модель файловой системы
    QFileSystemModel *model = new QFileSystemModel();

    // Устанавливаем корневую директорию (текущая папка проекта)
    model->setRootPath(QDir::currentPath());

    // Связываем модель с представлениями
    listView->setModel(model);
    treeView->setModel(model);

    // Устанавливаем корневой индекс для обоих представлений
    listView->setRootIndex(model->index(QDir::currentPath()));
    treeView->setRootIndex(model->index(QDir::currentPath()));

    // Настройки внешнего вида
    listView->setUniformItemSizes(true);
    treeView->setHeaderHidden(false);

    window.show();
    return app.exec();
}

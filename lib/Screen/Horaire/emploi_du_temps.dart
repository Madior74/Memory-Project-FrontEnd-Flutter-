import 'package:flutter/material.dart';
import 'package:multilevel_drawer/multilevel_drawer.dart';
import 'package:school_management_system/Widgets/drawer.dart';

class EmploisDuTemps extends StatelessWidget {
  const EmploisDuTemps({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "EMPLOI DU TEMPS",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 23),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      drawer: MyDrawer(),
      body: Center(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: FittedBox(
              child: Column(children: [
                const Row(
                  children: [
                    Image(
                        fit: BoxFit.fill,
                        width: 500,
                        image: AssetImage(
                          "assets/images/entete1.jpg",
                        )),
                    /*Text("EMPLOI DU TEMPS DU",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    TextField(
                      decoration: InputDecoration(
                          hintText: "LUNDI 10 AU SAMEDI 17 AVRIL"),
                    )*/
                  ],
                ),
                DataTable(
                  border: TableBorder.all(),
                  columns: const [
                    DataColumn(
                        label: Text(
                      'Horaire',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    )),
                    DataColumn(
                        label: Text(
                      'LUNDI',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    )),
                    DataColumn(
                        label: Text(
                      'MARDI',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    )),
                    DataColumn(
                        label: Text(
                      'MERCREDI ',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    )),
                    DataColumn(
                        label: Text(
                      'JEUDI',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    )),
                    DataColumn(
                        label: Text(
                      'VENDREDI',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    )),
                    DataColumn(
                        label: Text(
                      'SAMEDI',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    )),
                  ],
                  rows: const [
                    DataRow(
                      cells: [
                        DataCell(
                          Text("08h-09H\n"
                              "09H-10H"),
                        ),
                        DataCell(TextField(
                          decoration: InputDecoration(hintText: "CCNA"),
                        )),
                        DataCell(TextField(
                          decoration: InputDecoration(hintText: "COMPTABILITE"),
                        )),
                        DataCell(TextField(
                          decoration: InputDecoration(hintText: "ALGÈBRE"),
                        )),
                        DataCell(TextField(
                          decoration: InputDecoration(hintText: "ORACLE"),
                        )),
                        DataCell(TextField(
                          decoration: InputDecoration(hintText: "MERISE"),
                        )),
                        DataCell(TextField(
                          decoration:
                              InputDecoration(hintText: "DIGNITÉ HUMAINE"),
                        )),
                      ],
                    ),

                    // ...rows: const [
                    DataRow(cells: [
                      DataCell(Text("10H:00-10H:30")),
                      DataCell(Text("")),
                      DataCell(Text("")),
                      DataCell(Text(
                        "PAUSE",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.red),
                      )),
                      DataCell(Text("")),
                      DataCell(Text("")),
                      DataCell(Text("")),
                    ]),
                    DataRow(
                      cells: [
                        DataCell(Text('10H:30\n'
                            "13h:00")),
                        DataCell(TextField(
                            decoration: InputDecoration(
                          hintText: "Anglais",
                        ))),
                        DataCell(TextField(
                            decoration: InputDecoration(
                          hintText: "Comptabilite",
                        ))),
                        DataCell(TextField(
                            decoration: InputDecoration(
                          hintText: "Algebre",
                        ))),
                        DataCell(TextField(
                            decoration: InputDecoration(
                          hintText: "Oracle",
                        ))),
                        DataCell(TextField(
                            decoration: InputDecoration(
                          hintText: "Merise",
                        ))),
                        DataCell(TextField(
                            decoration: InputDecoration(
                          hintText: "Dignite Humaine",
                        ))),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('13H:00-'
                            "13h:45")),
                        DataCell(Text('')),
                        DataCell(Text('APRÈS',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: Colors.red))),
                        DataCell(Text('')),
                        DataCell(Text('')),
                        DataCell(Text(
                          'MIDI',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.red),
                        )),
                        DataCell(Text('')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('13H:45\n'
                            "16h:45")),
                        DataCell(TextField(
                            decoration: InputDecoration(
                          hintText: "Anglais",
                        ))),
                        DataCell(TextField(
                            decoration: InputDecoration(
                          hintText: "Anglais",
                        ))),
                        DataCell(TextField(
                            decoration: InputDecoration(
                          hintText: "Anglais",
                        ))),
                        DataCell(TextField(
                            decoration: InputDecoration(
                          hintText: "Anglais",
                        ))),
                        DataCell(TextField(
                            decoration: InputDecoration(
                          hintText: "",
                        ))),
                        DataCell(TextField(
                            decoration: InputDecoration(
                          hintText: " ",
                        ))),
                      ],
                    ),
                  ],
                  showCheckboxColumn: true,
                ),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}

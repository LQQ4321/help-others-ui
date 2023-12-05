import 'package:flutter/material.dart';
import 'package:help_them/pages/bodys/seekHelpList.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _TopBar(),
        Expanded(
            child: Container(
          color: const Color(0xfff6f6f6),
          padding:
              const EdgeInsets.only(right: 50, left: 50, top: 20, bottom: 20),
          child: Builder(
            builder: (BuildContext context) {
              if (true) {
                return const SeekHelpList();
              }
            },
          ),
        ))
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: const BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Color(0xffe7e8ec), width: 1.0))),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                const SizedBox(width: 20),
                Text(
                  'help others',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 16),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(120, 40)),
                  backgroundColor: MaterialStateColor.resolveWith(
                      (states) => Colors.grey[200]!)),
              child: Text(
                '2023-07-10',
                style: TextStyle(color: Colors.black45),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () {},
                    splashRadius: 20,
                    icon: Icon(Icons.person_outline)),
                const SizedBox(width: 10),
              ],
            ),
          )
        ],
      ),
    );
  }
}

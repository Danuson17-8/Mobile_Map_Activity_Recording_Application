import 'package:application_map_todolist/services/data_storage.dart';
import 'package:application_map_todolist/services/event_notification_service.dart';
import 'package:application_map_todolist/providers/event_provider.dart';
import 'package:application_map_todolist/screens/pin_screens/createpin_screen.dart';
import 'package:application_map_todolist/services/event_data_service.dart';
import 'package:application_map_todolist/units/dialog_helper.dart';
import 'package:application_map_todolist/units/funtion.dart';
import 'package:flutter/material.dart';
import 'package:application_map_todolist/services/pick_image.dart';
import 'package:provider/provider.dart';


class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late EventProvider provider;
  String? userPin;
  List<String> imageList = [];
  bool switchPin = false;
  bool switchNotify = true;
  Set<int> selectedIndices = {};

  @override
  void initState() {
    super.initState();
    provider = Provider.of<EventProvider>(context, listen: false);
    _loadPinAndSetting();
  }

  void _loadPinAndSetting() async {
    userPin = await EventStorage().loadPin();
    switchPin = await EventStorage().loadSettingPin();
    switchNotify = await EventStorage().loadSettingNotify();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Icon(
            Icons.settings,
            size: 40,
            color: const Color.fromARGB(255, 98, 197, 162),
          ),
        ),
        title: Text(
          'การตั้งค่า',
          style: TextStyle(
            fontSize: 25,
            color: Colors.black,
            fontWeight: FontWeight.bold
          )
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            firstTabMenu(
              onPressed: () {
                openPage(0);
              },
              textTabMenu: 'จัดการข้อมูลกิจกรรม',
              imageTabMenu: 'assets/image_setting/location.png',
            ),
            tapMenu(
              onPressed: () {
                openPage(1);
              },
              textTabMenu: 'จัดการรูปภาพ',
              imageTabMenu: 'assets/image_setting/image.png',
            ),
            tapMenu(
              onPressed: () {
                openPage(2);
              },
              textTabMenu: 'รหัส',
              imageTabMenu: 'assets/image_setting/padlock.png',
            ),
            lastTabMenu(
              onPressed: () {
                openPage(3);
              },
              textTabMenu: 'การแจ้งเตือน',
              imageTabMenu: 'assets/image_setting/bell.png',
            ),
            const SizedBox(height: 30),
            firstTabMenu(
              onPressed: () {
                openPage(4);
              },
              textTabMenu: 'วิธีใช้',
              imageTabMenu: 'assets/image_setting/help.png',
            ),
            lastTabMenu(
              onPressed: () {
                openPage(5);
              },
              textTabMenu: 'แชร์แอป',
              imageTabMenu: 'assets/image_setting/share.png',
            ),
            const SizedBox(height: 50),
            Center(
              child: Image.asset(
                height: 200,
                width: 200,
                'assets/image_sticker/sticker_setting.png'
              ),
            )
          ],
        ),
      ),
    );
  }

  void openPage(int page) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: const Color.fromARGB(255, 98, 197, 162),),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                title: Text(
                  page == 0 ? 'จัดการข้อมูลกิจกรรม' :
                  page == 1 ? 'จัดการรูปภาพ' :
                  page == 2 ? 'ความปลอดภัย' :
                  page == 3 ? 'การแจ้งเตือน' :
                  page == 4 ? 'วิธีการใช้งาน' : 'แชร์'
                ),
              ),
              body: page == 0 
                ? buildEventSettingsPage()
                : page == 1 
                ? buildImageSettingsPage(context, setState)
                : page == 2
                ? buildSecuritySettingsPage(context, setState) 
                : page == 3 
                ? buildNotifySettingsPage(context, setState) 
                : page == 4 
                ? buildHelpSettingsPage()
                : buildShare()
            );
          }
        );
      },
    );
  }

  //จัดการกิจกรรม
  Widget buildEventSettingsPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          firstTabMenu(
            onPressed: () async {
              await downloadEventsData(context);
            },
            textTabMenu: 'ดาวน์โหลดไฟล์ข้อมูลกิจกรรม (.json)',
            imageTabMenu: 'assets/image_setting/file.png',
          ),
          lastTabMenu(
            onPressed: () async {
              await provider.importFile(context);
            },
            textTabMenu: 'อัปโหลดข้อมูลกิจกกรม',
            imageTabMenu: 'assets/image_setting/upload-file.png',
          ),
          SizedBox(height: 5),
          Text('อัปโหลดไฟล์จากแอปพลิเคชันเท่านั้น (.json) !', style: TextStyle(color: const Color.fromARGB(255, 134, 134, 134)),),
          SizedBox(height: 300),
          SizedBox(
            height: 50,
            width: 170,
            child: TextButton.icon(
              onPressed:() async {
                final isDeleted = await DialogHelper.confirmDelete(
                  context: context,
                  text: 'ล้างข้อมูลกิจกรรมทั้งหมด',
                );
                if(isDeleted == true) {
                  provider.deleteAllEventAndMarker(context);
                }
              },
              icon: Image.asset('assets/image_setting/delete.png'),
              label: Text('ล้างข้อมูล', style: TextStyle( color: Colors.black),),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: Colors.white
              ),
            ),
          ),
          SizedBox(height: 5),
          Text('ลบข้อมูลกิจกรรมในแอปทั้งหมด !', style: TextStyle(color: const Color.fromARGB(255, 134, 134, 134)),),
        ]
      ),
    );
  }

  //จัดการรูปภาพ
  Widget buildImageSettingsPage(BuildContext context, Function setState) {
    imageList = Provider.of<EventProvider>(context).images;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(8.0),
            height: 560,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromARGB(255, 98, 197, 162),
                width: 2,
              ),
              color: const Color.fromARGB(255, 250, 250, 250),
              borderRadius: BorderRadius.circular(20),
            ),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: imageList.length,
              itemBuilder: (BuildContext context, int index) {
                final isSelected = selectedIndices.contains(index);
                return GestureDetector(
                  onLongPress: () {
                    setState(() {
                      if (isSelected) {
                        selectedIndices.remove(index);
                      } else {
                        selectedIndices.add(index);
                      }
                    });
                  },
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected ? const Color.fromARGB(255, 98, 197, 162) : Colors.transparent,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: resolveImageWidget(imagePath: imageList[index])
                      ),
                      if (isSelected)
                        const Positioned(
                          top: 5,
                          right: 5,
                          child: Icon(
                            Icons.check_circle,
                            color: Color.fromARGB(255, 98, 197, 162),
                            size: 24,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 10),
          Container(
              padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 98, 197, 162),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 45,
                  width: 220,
                  child: TextButton.icon(
                    onPressed: () async {
                      await pickImage(context, imageList);
                    },
                    icon: Image.asset('assets/image_setting/addimage.png'),
                    label: Text('เพิ่มรูปภาพ', style: TextStyle(color: Colors.black, fontSize: 15),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                SizedBox(width: 26),
                SizedBox(
                  height: 45,
                  width: 70,
                  child: IconButton(
                    onPressed: selectedIndices.isEmpty
                      ? () {}
                      : () {
                          setState (() {
                            selectedIndices.toList()
                              ..sort((a, b) => b.compareTo(a)) // ลบจากหลังสุด
                              ..forEach((index) {
                                imageList.removeAt(index);
                            });
                          });
                          provider.addImage(imageList);
                          selectedIndices.clear();
                        },
                    icon: Icon(Icons.delete, color: selectedIndices.isEmpty ? Colors.grey : const Color.fromARGB(255, 122, 34, 29),),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      backgroundColor: selectedIndices.isEmpty ? Colors.white : const Color.fromARGB(255, 242, 128, 120),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //ความปลอดภัย
  Widget buildSecuritySettingsPage(BuildContext context, Function setState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Container(
            width: 400,
            height: 250,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12)
            ),
            child: Container(
                height: 200,
                width: 200,
                child: Image.asset(switchPin == true ? 'assets/image_setting/appicon_lock.png' : 'assets/image_setting/appicon_unlock.png'),
              ),
        ),
        const SizedBox(height: 20),
        tabMenuTextAndSwitch(
          onChanged: (bool value) {
            setState(() {
              switchPin = value;
              EventStorage().saveSettingPin(switchPin);
            });
          },
          textTabmMenu: 'ความปลอดภัย',
          switchValue: switchPin
        ),
        const SizedBox(height: 30),
        if(switchPin)
          firstTabMenu(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreatePinScreen()),
              );
            },
            textTabMenu: 'เปลี่ยนรหัสผ่าน PIN',
          ),
        if(switchPin)
          lastTabMenu(
            onPressed: userPin == null
              ? () { 
              }
              : () { 
                EventStorage().deletePin();
              },
            textTabMenu: 'ลบรหัสผ่าน',
          ),
        ],
      )
    );
  }

  //การแจ้งเตือน
  Widget buildNotifySettingsPage(BuildContext context, Function setState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Container(
            width: 400,
            height: 250,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12)
            ),
            child: Container(
              height: 200,
              width: 200,
              child: Image.asset(switchNotify == true ? 'assets/image_setting/appicon_ntf_on.png' : 'assets/image_setting/appicon_ntf_off.png'),
            ),
          ),
          const SizedBox(height: 20),
          tabMenuTextAndSwitch(
            onChanged: (bool value) {
            setState(() {
              switchNotify = value;
              EventStorage().saveSettingNotify(switchNotify);
              if (switchNotify) {
                final events = provider.events;
                for (var event in events) {
                  notificationService.scheduleNotification(
                    event.to.hashCode, event.title, event.description,
                    event.from, event.to, event.notiStart, event.notiEnd
                  );
                }
              } else {
                // ปิดแจ้งเตือนทั้งหมด
                notificationService.cancelAllNotifications();
              }
            });
          },
            textTabmMenu: 'การเเจ้งเตือน',
            switchValue: switchNotify
          ),
          ],
        )
    );
  }

  //วิธีการใช้งาน
  Widget buildHelpSettingsPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            SizedBox(
              height: 50,
              width: 300,
              child: TextButton.icon(
                onPressed:() async {
                  DialogHelper.showHowToUseAppDialog(context);
                },
                icon:  Icon(Icons.slideshow, color: const Color.fromARGB(255, 98, 197, 162), size: 30,),
                label: Text('วิธีการใช้งาน', style: TextStyle( color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Colors.white
                ),
              ),
            ),
            const SizedBox(height: 40),
            buildHeader(text: 'เพิ่มกิจกรรม & ตำแหน่งบนแผนที่', icon: Icons.add_box),
            const SizedBox(height: 10),
            buildExpansionTile(
              listText: [
                buildText(text: '1. แตะบนแผนที่เพื่อเลือกตำแหน่ง'),
                buildText(text: '2. แตะปุ่มเพิ่มกิจกรรม'),
                buildText(text: '3. แตะรูปภาพเพื่อเลือกรูปภาพของ หมุดบนแผนที่เเละ กิจกรรม'),
                buildText(text: '4. กดยืนยัน ✅'),
                buildText(text: '5. ป้อนข้อมูล เช่น ชื่อกิจกรรม, รายละเอียด, วันที่เเละ เวลา'),
                buildText(text: '6. กดบันทึก ✅'),
                const SizedBox(height: 10),
              ],
              title: 'หน้าแผนที่'
            ),
            buildExpansionTile(
              listText: [
                buildText(text: '1. กดปุ่ม ➕ เพื่อเพิ่มกิจกรรมตามตำเเหน่งผู้ใช้'),
                buildText(text: '2. แตะรูปภาพเพื่อเลือกรูปภาพของ หมุดบนแผนที่เเละ กิจกรรม'),
                buildText(text: '3. กดยืนยัน ✅'),
                buildText(text: '4. ป้อนข้อมูล เช่น ชื่อกิจกรรม, รายละเอียด, วันที่เเละ เวลา'),
                buildText(text: '5. กดบันทึก ✅'),
                const SizedBox(height: 10),
              ],
              title: 'หน้าอื่นๆ'
            ),
          ],
        ),
      ),
    );
  }

  Widget buildShare() {
    return Align(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            width: 300, // กำหนดขนาดของกรอบ
            height: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16), // ขอบมน
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), 
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Image.asset('assets/image_setting/Qrcode_app.png')
          ),
          SizedBox(height: 10), // เว้นระยะห่างระหว่างกรอบกับข้อความ
          Text(
            'Qr code Application',
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
          SizedBox(height: 100),
          Center(
            child: Image.asset(
              height: 200,
              width: 200,
              'assets/image_sticker/sticker_love.png'
            ),
          )
        ],
      ),
    );
  }

  Widget buildText({required String text}) => Padding(
    padding: EdgeInsets.only(left: 35),
    child: Text(text, style: TextStyle(fontSize: 16, color: const Color.fromARGB(255, 87, 87, 87))),
  );

  Widget buildHeader({required String text, required IconData icon}) => Row(
    children: [
      Container(
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: const Color.fromARGB(255, 98, 197, 162)
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20,),
          ],
        )
      ),
    const SizedBox(width: 10),
    Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    ],
  );

  Widget buildExpansionTile ({required List<Widget> listText, required String title}) => ExpansionTile(
    expandedCrossAxisAlignment: CrossAxisAlignment.start,
    title: Row(
      children: [
        Icon(Icons.brightness_1 , color: const Color.fromARGB(255, 98, 197, 162), size: 15,),
        const SizedBox(width: 5),
        Text( title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
      ],
    ),
    children: listText,
  );

  Widget firstTabMenu({required VoidCallback onPressed, required String textTabMenu, String imageTabMenu = ''}) => ClipRRect(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(15),
      topRight: Radius.circular(15),
    ),
    child: tapMenu(onPressed: onPressed, textTabMenu: textTabMenu, imageTabMenu: imageTabMenu),
  );

  Widget tapMenu({required VoidCallback onPressed, required String textTabMenu, String imageTabMenu = ''}) => ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      minimumSize: Size(double.infinity, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if(imageTabMenu != '')
        Image.asset(
          imageTabMenu,
          width: 24,
          height: 24,
        ),
        if(imageTabMenu != '')
        SizedBox(width: 20),
        Text( textTabMenu, style: TextStyle(color: Colors.black)),
      ],
    ),
  );

  Widget lastTabMenu({required VoidCallback onPressed, required String textTabMenu, String imageTabMenu = ''}) => ClipRRect(
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(15),
      bottomRight: Radius.circular(15),
    ),
    child: tapMenu(onPressed: onPressed, textTabMenu: textTabMenu, imageTabMenu: imageTabMenu),
  );

  Widget tabMenuTextAndSwitch({required Function(bool) onChanged, required String textTabmMenu, required bool switchValue}) => Container(
    height: 60,
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12)
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(textTabmMenu, style: TextStyle(fontSize: 16)),
        Switch(
          activeColor: const Color.fromARGB(255, 98, 197, 162),
          value: switchValue,
          onChanged: onChanged,
        ),
      ],
    ),
  );

}

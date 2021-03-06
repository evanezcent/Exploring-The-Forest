import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:register/ui/components/circle-ripple.dart';
import 'package:register/ui/components/circle-timeline.dart';
import 'package:register/ui/components/curve-wave.dart';
import 'package:register/ui/components/long_button.dart';
import 'package:register/ui/components/password-requirement.dart';
import 'package:register/ui/components/timeline.dart';
import 'package:register/ui/screens/success_screen.dart';
import 'package:register/utils/constants.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen>
    with TickerProviderStateMixin {
  TextEditingController passwordController = TextEditingController();
  bool hide = true;
  String choosedIncome = "0";
  String choosedExpense = "0";
  late AnimationController _animationController;

  late AnimationController _iconController;
  late Animation<double> _pulseAnimation;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  String choosedDate = "- Choosed Date -";
  String choosedTime = "- Choosed Time -";

  bool valid = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _iconController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    _iconController.forward();

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1).animate(
        CurvedAnimation(parent: _iconController, curve: Curves.easeIn));

    _pulseAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed)
        _iconController.reverse();
      else if (status == AnimationStatus.dismissed) _iconController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: custom_blue,
        centerTitle: false,
        title: Text(
          "Create Account",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      backgroundColor: custom_blue,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Timeline(
              index: 4,
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: CustomPaint(
                    painter: CirclePainter(
                      _animationController,
                      color: Colors.white,
                    ),
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: rippleComponents(_pulseAnimation),
                    ),
                  ),
                ),
              ],
            ),
            Text("Schedule Video Call", style: white_800_20),
            SizedBox(height: 6),
            Text(
                "Choose the date and time you preferred, we will send a link via email to make a video call on the scheduled date and time.",
                style: white_normal_14),
            SizedBox(height: 30),
            InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                selectDate(context);
              },
              child: Container(
                height: 50,
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Date",
                      style: grey_normal_12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "$choosedDate",
                          style: black_semi_16,
                        ),
                        Icon(Icons.arrow_drop_down, color: Colors.grey)
                      ],
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () => selectDate(context, type: "time"),
              child: Container(
                height: 50,
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Time",
                      style: grey_normal_12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "$choosedTime",
                          style: black_semi_16,
                        ),
                        Icon(Icons.arrow_drop_down, color: Colors.grey)
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: 40, right: 20, left: 20),
        child: LongButton(
            bgColor: valid ? custom_blue_disable : custom_blue,
            textColor: Colors.white,
            loading: false,
            width: size.width,
            title: "Next",
            onClick: () {
              if (valid)
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SuccessScreen()));
            }),
      ),
    );
  }

  // select date function
  void selectDate(BuildContext context, {String type = "date"}) async {
    final ThemeData theme = Theme.of(context);
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return buildMaterialDatePicker(context, type: type);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return buildCupertinoDatePicker(context, type: type);
    }
  }

  /// Android date picker
  buildMaterialDatePicker(BuildContext context, {String type = "date"}) async {
    if (type == "date") {
      DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2021),
        lastDate: DateTime(2500),
      );
      if (picked != null && picked != selectedDate)
        setState(() {
          selectedDate = picked;
          choosedDate =
              "${selectedDate.day} - ${selectedDate.month} - ${selectedDate.year}";
          valid = choosedTime != "- Choosed Time -" &&
              choosedDate != "- Choosed Date -";
        });
    } else {
      TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: selectedTime,
      );
      if (picked != null)
        setState(() {
          selectedTime = picked;
          String hour = picked.hour < 10 ? "0${picked.hour}" : "${picked.hour}";
          String min =
              picked.minute < 10 ? "0${picked.minute}" : "${picked.minute}";
          setState(() {
            choosedTime = "$hour:$min";
            valid = choosedTime != "- Choosed Time -" &&
                choosedDate != "- Choosed Date -";
          });
        });
    }
  }

  /// iOS date picker
  buildCupertinoDatePicker(BuildContext context, {String type = "date"}) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            color: Colors.white,
            child: type == "time"
                ? CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    onDateTimeChanged: (picked) {
                      if (picked != selectedDate) {
                        String hour = picked.hour < 10
                            ? "0${picked.hour}"
                            : "${picked.hour}";
                        String min = picked.minute < 10
                            ? "0${picked.minute}"
                            : "${picked.minute}";
                        setState(() {
                          choosedTime = "$hour:$min";
                          valid = choosedTime != "- Choosed Time -" &&
                              choosedDate != "- Choosed Date -";
                        });
                      }
                    },
                    initialDateTime: selectedDate,
                    minimumYear: 2021,
                    maximumYear: 2500,
                  )
                : CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (picked) {
                      if (picked != selectedDate)
                        setState(() {
                          selectedDate = picked;
                          choosedDate =
                              "${selectedDate.day} - ${selectedDate.month} - ${selectedDate.year}";
                          valid = choosedTime != "- Choosed Time -" &&
                              choosedDate != "- Choosed Date -";
                        });
                    },
                    initialDateTime: selectedDate,
                    minimumYear: 2021,
                    maximumYear: 2500,
                  ),
          );
        });
  }

  Widget rippleComponents(Animation<double> pulse) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: <Color>[
                Color.lerp(Colors.white, custom_blue_disable, 0.6)!,
                Colors.white,
              ],
            ),
          ),
          child: ScaleTransition(
            scale: Tween(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: CurveWave(),
              ),
            ),
            child: ScaleTransition(
              scale: _pulseAnimation,
              child: Container(
                padding: EdgeInsets.all(2),
                color: Colors.white,
                child: Icon(
                  Icons.calendar_today_sharp,
                  color: custom_blue,
                  size: 30,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

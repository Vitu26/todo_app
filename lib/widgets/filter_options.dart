import 'package:flutter/material.dart';

class FilterOptions extends StatefulWidget {
  final String selectedPriorityTemp;
  final String selectedStatusTemp;
  final Function(String) onPrioritySelected;
  final Function(String) onStatusSelected;
  final Function() onOkPressed;

  FilterOptions({
    required this.selectedPriorityTemp,
    required this.selectedStatusTemp,
    required this.onPrioritySelected,
    required this.onStatusSelected,
    required this.onOkPressed,
  });

  @override
  _FilterOptionsState createState() => _FilterOptionsState();
}

class _FilterOptionsState extends State<FilterOptions> {
  late String _selectedPriority;
  late String _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedPriority = widget.selectedPriorityTemp;
    _selectedStatus = widget.selectedStatusTemp;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Filter by Status:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildGradientButton(
                'All',
                _selectedStatus == 'All',
                () {
                  setState(() {
                    _selectedStatus = 'All';
                    widget.onStatusSelected(_selectedStatus);
                  });
                },
              ),
              _buildGradientButton(
                'Completed',
                _selectedStatus == 'Completed',
                () {
                  setState(() {
                    _selectedStatus = 'Completed';
                    widget.onStatusSelected(_selectedStatus);
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          Text('Filter by Priority:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildGradientButton(
                'All',
                _selectedPriority == 'All',
                () {
                  setState(() {
                    _selectedPriority = 'All';
                    widget.onPrioritySelected(_selectedPriority);
                  });
                },
              ),
              _buildGradientButton(
                'High',
                _selectedPriority == 'High',
                () {
                  setState(() {
                    _selectedPriority = 'High';
                    widget.onPrioritySelected(_selectedPriority);
                  });
                },
              ),
              _buildGradientButton(
                'Moderate',
                _selectedPriority == 'Moderate',
                () {
                  setState(() {
                    _selectedPriority = 'Moderate';
                    widget.onPrioritySelected(_selectedPriority);
                  });
                },
              ),
              _buildGradientButton(
                'Low',
                _selectedPriority == 'Low',
                () {
                  setState(() {
                    _selectedPriority = 'Low';
                    widget.onPrioritySelected(_selectedPriority);
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          Center(
            child: Container(
              width: 150,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.lightBlueAccent, Colors.blue.shade900],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                onPressed: widget.onOkPressed,
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientButton(String text, bool isSelected, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        gradient: isSelected
            ? LinearGradient(
                colors: [Colors.lightBlueAccent, Colors.blue.shade900],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

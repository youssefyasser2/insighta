import 'package:flutter/material.dart';
import 'package:test_app/features/completeprofile/controller_completeprofile.dart';

class StepInfoPage extends StatefulWidget {
  final CompleteProfileController controller;
  final bool isLoading;

  const StepInfoPage({
    super.key,
    required this.controller,
    required this.isLoading,
  });

  @override
  State<StepInfoPage> createState() => _StepInfoPageState();
}

class _StepInfoPageState extends State<StepInfoPage>
    with SingleTickerProviderStateMixin {
  // Animation controller for suffix icon rotation
  late AnimationController _suffixIconController;
  late Animation<double> _suffixIconRotation;

  // Local variable to store parent status
  bool? _isParent;

  // Define age ranges and icons as constants
  static const List<String> _ageRanges = [
    '6-8 (Early Primary Child)',
    '9-12 (Senior Primary Child)',
    '13-15 (Young Teen)',
    '16-18 (Teen)',
    '19-24 (Young Adult)',
    '25-34 (Young Adult)',
    '35-44 (Adult)',
    '45-54 (Middle Age)',
    '55-64 (Pre-Senior)',
    '65+ (Senior)',
  ];

  static const List<IconData> _ageRangeIcons = [
    Icons.child_care,
    Icons.child_friendly,
    Icons.face,
    Icons.person,
    Icons.person_outline,
    Icons.person_pin,
    Icons.person_2,
    Icons.person_3,
    Icons.person_4,
    Icons.elderly,
  ];

  @override
  void initState() {
    super.initState();
    // Initialize animation controller for suffix icon
    _suffixIconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _suffixIconRotation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _suffixIconController, curve: Curves.easeInOut),
    );
    // Debug ageController changes
    widget.controller.ageController.addListener(() {
      print(
        'ageController.text changed to: "${widget.controller.ageController.text}"',
      );
    });
  }

  @override
  void dispose() {
    _suffixIconController.dispose();
    super.dispose();
  }

  // Show bottom sheet for age range selection
  void _showAgeRangeSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Colors.grey.shade50],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Bottom sheet title with close button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Select Age Range',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Age range list using ListView.builder
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  cacheExtent: 1000,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _ageRanges.length,
                  itemBuilder: (context, index) {
                    final range = _ageRanges[index];
                    final icon = _ageRangeIcons[index];
                    final isSelected =
                        widget.controller.ageController.text == range;
                    return Column(
                      children: [
                        _AgeRangeTile(
                          range: range,
                          icon: icon,
                          isSelected: isSelected,
                          onTap: () {
                            widget.controller.ageController.text = range;
                            print('Selected age range: "$range"');
                            setState(() {}); // Ensure UI updates
                            Navigator.pop(context);
                          },
                        ),
                        Divider(height: 1, color: Colors.grey.shade300),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    ).whenComplete(() {
      // Reset suffix icon animation when bottom sheet closes
      _suffixIconController.reverse();
    });
  }

  // Callback to update state when gender is selected
  void _onGenderSelected(Gender gender) {
    setState(() {
      widget.controller.updateGender(gender);
    });
  }

  // Callback to update state when parent status is selected
  void _onParentStatusSelected(bool isParent) {
    setState(() {
      _isParent = isParent;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: widget.controller.formKeys[1],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              // Page title
              Text(
                'Let’s Get to Know You Better',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: CompleteProfileController.primaryColor,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 8),
              // Page subtitle
              Text(
                'Please provide some details to tailor your journey with us and make it more enjoyable.',
                style: textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              // Age field
              Text(
                'Age Range',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.white, Colors.grey.shade50],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 10,
                      spreadRadius: 3,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextFormField(
                  readOnly: true,
                  enabled: !widget.isLoading,
                  controller: widget.controller.ageController,
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight:
                        widget.controller.ageController.text.isNotEmpty
                            ? FontWeight.bold
                            : FontWeight.normal,
                    color:
                        widget.controller.ageController.text.isNotEmpty
                            ? CompleteProfileController.primaryColor
                            : theme.colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Select your age range',
                    filled: true,
                    fillColor: Colors.transparent,
                    prefixIcon: Icon(
                      Icons.calendar_today,
                      color: theme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    suffixIcon: RotationTransition(
                      turns: _suffixIconRotation,
                      child: const Icon(
                        Icons.arrow_drop_down,
                        size: 28,
                        color: Colors.grey,
                      ),
                    ),
                    hintStyle: textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant.withOpacity(
                        0.6,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: theme.colorScheme.outline,
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: theme.colorScheme.outline,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: CompleteProfileController.primaryColor,
                        width: 2.5,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: theme.colorScheme.error,
                        width: 1.5,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: theme.colorScheme.error,
                        width: 2.5,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 20,
                    ),
                  ),
                  onTap: () {
                    // Animate suffix icon on tap
                    _suffixIconController.forward();
                    _showAgeRangeSelection(context);
                  },
                  validator: (val) {
                    print('Validator input: "$val"');
                    if (val == null || val.trim().isEmpty) {
                      return 'Age is required';
                    }
                    if (!_ageRanges.contains(val.trim())) {
                      print('Available ranges: $_ageRanges');
                      return 'Select a valid age range';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Gender selection
              Text(
                'Gender',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _GenderTile(
                    gender: Gender.male,
                    label: 'Male',
                    icon: Icons.male,
                    isSelected: widget.controller.selectedGender == Gender.male,
                    isLoading: widget.isLoading,
                    onTap: () => _onGenderSelected(Gender.male),
                  ),
                  const SizedBox(width: 16),
                  _GenderTile(
                    gender: Gender.female,
                    label: 'Female',
                    icon: Icons.female,
                    isSelected:
                        widget.controller.selectedGender == Gender.female,
                    isLoading: widget.isLoading,
                    onTap: () => _onGenderSelected(Gender.female),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Parent status selection
              Text(
                'Are you a parent?',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ParentStatusTile(
                    isParent: true,
                    label: 'Yes',
                    icon: Icons.family_restroom,
                    isSelected: _isParent == true,
                    isLoading: widget.isLoading,
                    onTap: () => _onParentStatusSelected(true),
                  ),
                  const SizedBox(width: 16),
                  _ParentStatusTile(
                    isParent: false,
                    label: 'No',
                    icon: Icons.person,
                    isSelected: _isParent == false,
                    isLoading: widget.isLoading,
                    onTap: () => _onParentStatusSelected(false),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom widget for gender selection tile with scale animation
class _GenderTile extends StatefulWidget {
  final Gender gender;
  final String label;
  final IconData icon;
  final bool isSelected;
  final bool isLoading;
  final VoidCallback onTap;

  const _GenderTile({
    required this.gender,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.isLoading,
    required this.onTap,
  });

  @override
  _GenderTileState createState() => _GenderTileState();
}

class _GenderTileState extends State<_GenderTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Expanded(
      child: GestureDetector(
        onTapDown: (_) {
          if (!widget.isLoading) _animationController.forward();
        },
        onTapUp: (_) {
          if (!widget.isLoading) {
            _animationController.reverse();
            widget.onTap();
          }
        },
        onTapCancel: () {
          if (!widget.isLoading) _animationController.reverse();
        },
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color:
                  widget.isSelected
                      ? CompleteProfileController.primaryColor.withOpacity(0.3)
                      : Colors.white,
              border: Border.all(
                color:
                    widget.isSelected
                        ? CompleteProfileController.primaryColor
                        : theme.colorScheme.outline,
                width: widget.isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.icon,
                  size: 32,
                  color:
                      widget.isSelected
                          ? CompleteProfileController.primaryColor
                          : theme.colorScheme.onSurfaceVariant,
                  semanticLabel: widget.label,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.label.toUpperCase(),
                  style: textTheme.bodyMedium?.copyWith(
                    color:
                        widget.isSelected
                            ? CompleteProfileController.primaryColor
                            : theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Custom widget for parent status selection tile with scale animation
class _ParentStatusTile extends StatefulWidget {
  final bool isParent;
  final String label;
  final IconData icon;
  final bool isSelected;
  final bool isLoading;
  final VoidCallback onTap;

  const _ParentStatusTile({
    required this.isParent,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.isLoading,
    required this.onTap,
  });

  @override
  _ParentStatusTileState createState() => _ParentStatusTileState();
}

class _ParentStatusTileState extends State<_ParentStatusTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Expanded(
      child: GestureDetector(
        onTapDown: (_) {
          if (!widget.isLoading) _animationController.forward();
        },
        onTapUp: (_) {
          if (!widget.isLoading) {
            _animationController.reverse();
            widget.onTap();
          }
        },
        onTapCancel: () {
          if (!widget.isLoading) _animationController.reverse();
        },
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color:
                  widget.isSelected
                      ? CompleteProfileController.primaryColor.withOpacity(0.3)
                      : Colors.white,
              border: Border.all(
                color:
                    widget.isSelected
                        ? CompleteProfileController.primaryColor
                        : theme.colorScheme.outline,
                width: widget.isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.icon,
                  size: 32,
                  color:
                      widget.isSelected
                          ? CompleteProfileController.primaryColor
                          : theme.colorScheme.onSurfaceVariant,
                  semanticLabel: widget.label,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.label.toUpperCase(),
                  style: textTheme.bodyMedium?.copyWith(
                    color:
                        widget.isSelected
                            ? CompleteProfileController.primaryColor
                            : theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Custom widget for age range tile with scale animation
class _AgeRangeTile extends StatefulWidget {
  final String range;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _AgeRangeTile({
    required this.range,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  _AgeRangeTileState createState() => _AgeRangeTileState();
}

class _AgeRangeTileState extends State<_AgeRangeTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) {
        _animationController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _animationController.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          color:
              widget.isSelected
                  ? CompleteProfileController.primaryColor.withOpacity(0.2)
                  : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 24,
                color:
                    widget.isSelected
                        ? CompleteProfileController.primaryColor
                        : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.range,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                        widget.isSelected ? FontWeight.bold : FontWeight.normal,
                    color:
                        widget.isSelected
                            ? CompleteProfileController.primaryColor
                            : theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

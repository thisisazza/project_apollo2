              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Mock Logo Area
            Container(
              width: 80,
              height: double.infinity,
              decoration: BoxDecoration(
                color: club.primaryColor.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
              child: Icon(Icons.shield, color: club.primaryColor, size: 40),
            ),
            const SizedBox(width: 24),
            // Text Info
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    club.name,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: club.primaryColor,
                    ),
                  ),
                  Text(
                    'JOIN THE REVOLUTION',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            // Arrow
            Padding(
              padding: const EdgeInsets.only(right: 24.0),
              child: Icon(Icons.arrow_forward_ios, color: club.primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}

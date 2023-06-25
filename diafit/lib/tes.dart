Container(
              padding = const EdgeInsets.symmetric(horizontal: 25),
              width = MediaQuery.of(context).size.width,
              height = MediaQuery.of(context).size.height / 8.5,
              decoration = const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 168, 138, 205),
                    Color.fromARGB(255, 93, 56, 240)
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child = Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Order List",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/cross-icon.png"),
                        fit: BoxFit.cover,
                        opacity: .8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height = 25,
            ),
            Container(
              padding = const EdgeInsets.all(10),
              width = MediaQuery.of(context).size.width / 1.1,
              height = 110,
              decoration = BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0, 5.0),
                    blurRadius: 20,
                    spreadRadius: -20,
                  ),
                ],
              ),
              child = Row(
                children: [
                  Container(
                    width: 110,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/chicken.png"),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 5),
                          child: const Text(
                            "Fried Chicken",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          width: 70,
                          height: 27,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "-",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                "2",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                "+",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 115,
                    height: 60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Rp. 60.000",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

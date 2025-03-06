<?php
// Function to read cities from a CSV file
function readCitiesFromCSV($filename) {
    $cities = [];
    if (($handle = fopen($filename, "r")) !== FALSE) {
        while (($data = fgetcsv($handle, 1000, ",")) !== FALSE) {
            $id = $data[0];
            $city = $data[1];
            $cities[$city] = $id;
        }
        fclose($handle);
    }
    return $cities;
}

// Path to the CSV file
$csvFile = "cities.csv";

// Read cities from the CSV file
$cities = readCitiesFromCSV($csvFile);

// Function to scrape prayer times
function scrapeWebsite($ville) {
    $url = "https://www.habous.gov.ma/prieres/horaire-api.php?ville=$ville";
    $context = stream_context_create([
        "ssl" => [
            "verify_peer" => false,
            "verify_peer_name" => false,
        ],
    ]);
    $html = file_get_contents($url, false, $context);

    $dom = new DOMDocument();
    @$dom->loadHTML($html);
    $xpath = new DOMXPath($dom);

    $products = [];
    $res = [];
    $rows = $xpath->query("//table//tr");
    foreach ($rows as $row) {
        $cells = $xpath->query(".//td", $row);
        foreach ($cells as $cell) {
            $products[] = trim($cell->textContent);
        }
    }

    $ob = [
        "salat" => "",
        "time" => "",
    ];
    foreach ($products as $i => $el) {
        if ($i % 2 == 0) {
            $ob["salat"] = trim(explode(":", $el)[0]);
        } else {
            $ob["time"] = trim($el);
            $res[] = $ob;
        }
    }
    return $res;
}

// Get the selected city from the query string
$selectedCity = $_GET["ville"] ?? 108; // Default to the first city in the CSV
$prayerTimes = scrapeWebsite($selectedCity);

// Generate the HTML
echo <<<HTML
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Prayer Times</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background: url('https://shemstravel.com/assets/site/images/posts/ow6gm07qxi.jpg') no-repeat center center fixed;
            background-size: cover;
        }
        .container {
            background-color: rgba(255, 255, 255, 0.9);
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
            width: 350px;
            text-align: center;
        }
        h1 {
            color: #333;
            margin-bottom: 20px;
        }
        .prayer-time {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #ddd;
        }
        .prayer-time:last-child {
            border-bottom: none;
        }
        .prayer-time span {
            font-weight: bold;
            color: #555;
        }
        select {
            padding: 10px;
            font-size: 16px;
            border-radius: 5px;
            border: 1px solid #ddd;
            width: 100%;
            margin-bottom: 20px;
            background-color: #fff;
        }
        .countdown {
            font-size: 24px;
            font-weight: bold;
            color: #333;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>مواقيت الصلاة</h1>
        <form method="GET" action="">
            <select name="ville" onchange="this.form.submit()">
HTML;

// Populate the dropdown with cities from the CSV
foreach ($cities as $city => $id) {
    $selected = $id == $selectedCity ? "selected" : "";
    echo "<option value=\"$id\" $selected>$city</option>";
}

echo <<<HTML
            </select>
        </form>
HTML;

// Display the prayer times
foreach ($prayerTimes as $item) {
    echo <<<HTML
        <div class="prayer-time">
            <span>{$item["salat"]}</span>
            <span>{$item["time"]}</span>
        </div>
HTML;
}

// Add the countdown section
echo <<<HTML
        <div class="countdown" id="countdown">Next Salat: Loading...</div>
    </div>
    <script>
        const prayerTimes = [
HTML;

// Pass prayer times to JavaScript
foreach ($prayerTimes as $item) {
    echo "{ salat: '{$item["salat"]}', time: '{$item["time"]}' },";
}

echo <<<HTML
        ];

        function updateCountdown() {
            const now = new Date();
            let nextPrayer = null;
            let nextPrayerTime = null;

            // Find the next prayer time
            for (const prayer of prayerTimes) {
                const prayerTime = new Date(now.toDateString() + " " + prayer.time);
                if (prayerTime > now) {
                    nextPrayer = prayer.salat;
                    nextPrayerTime = prayerTime;
                    break;
                }
            }

            // If no next prayer today, use the first prayer of the next day
            if (!nextPrayer) {
                nextPrayer = prayerTimes[0].salat;
                nextPrayerTime = new Date(now.toDateString() + " " + prayerTimes[0].time);
                nextPrayerTime.setDate(nextPrayerTime.getDate() + 1);
            }

            // Calculate the time difference
            const diff = nextPrayerTime - now;
            const hours = Math.floor(diff / (1000 * 60 * 60));
            const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
            const seconds = Math.floor((diff % (1000 * 60)) / 1000);

            // Display the countdown
            document.getElementById("countdown").innerHTML = 
                nextPrayer + " بعد " + 
                String(hours).padStart(2, '0') + ":" + 
                String(minutes).padStart(2, '0') + ":" + 
                String(seconds).padStart(2, '0');
        }

        // Update the countdown every second
        setInterval(updateCountdown, 1000);
        updateCountdown(); // Initial call
    </script>
</body>
</html>
HTML;
?>
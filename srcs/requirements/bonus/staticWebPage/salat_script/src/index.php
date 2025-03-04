<?php
// Map of cities and their corresponding ville numbers

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

$csvFile = "arabic.csv";

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
$selectedCity = $_GET["ville"] ?? 108; // Default to Casablanca
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
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            flex-direction: column;
        }
        .container {
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            width: 300px;
            margin-bottom: 20px;
        }
        h1 {
            text-align: center;
            color: #333;
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
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Prayer Times</h1>
        <form method="GET" action="">
            <select name="ville" onchange="this.form.submit()">
HTML;

// Populate the dropdown with cities
foreach ($cities as $name => $value) {
    $selected = $value == $selectedCity ? "selected" : "";
    echo "<option value=\"$value\" $selected>$name</option>";
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

echo <<<HTML
    </div>
</body>
</html>
HTML;
?>
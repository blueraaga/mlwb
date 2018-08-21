import re

hash_file = open('/vagrant/resources/apps/spark-2.3.1-bin-hadoop2.7.tgz.sha512', 'r')
hash_file_content = hash_file.read()
hash_file.close()

hash_components = hash_file_content.split(":")
new_hash_file_content_part1 = re.sub("[^a-f^A-F^0-9]", "", hash_components[1]).lower()
new_hash_file_content_part2 = hash_components[0]

new_hash_file = open("/vagrant/resources/apps/local-spark-hash.sha512", "w")
new_hash_file_content = new_hash_file_content_part1 + "  " + new_hash_file_content_part2
new_hash_file.write(new_hash_file_content)
new_hash_file.close()

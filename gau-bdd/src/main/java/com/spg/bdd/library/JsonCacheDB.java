package com.spg.bdd.library;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.Reader;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import gherkin.deps.com.google.gson.Gson;

/**
 * JsonCacheDB will read all the JSON's from json repository and will cache them in memory
 * 
 * @author jvadisela
 *
 */
public class JsonCacheDB {

	private Map<String, Employee> cache = null;

	public JsonCacheDB() {
		cache = readAllJsonsFromRepo();
	}

	private Map<String, Employee> readAllJsonsFromRepo() {
		Map<String, Employee> cache = new HashMap<String, Employee>();
		try (Stream<Path> walk = Files.walk(Paths.get("./json_repo/"))) {
			List<File> result = walk.map(x -> x.toFile()).filter(f -> f.getName().endsWith(".json"))
					.collect(Collectors.toList());
			for(File f: result) {
				try (Reader reader = new FileReader(f)) {
					Gson gson = new Gson();
					Employee o = gson.fromJson(reader, Employee.class);
		            cache.put(f.getName(), o);
		        } catch (IOException e) {
		            e.printStackTrace();
		        }
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		return cache;
	}

	public Object getJson(String fileName) {
		return cache.get(fileName);
	}
	
	public static void main(String[] args) {
		JsonCacheDB cacheDB = new JsonCacheDB();
		System.out.println(cacheDB.getJson("default.json"));
	}

}

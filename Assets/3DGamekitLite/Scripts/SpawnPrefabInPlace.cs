using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnPrefabInPlace : MonoBehaviour
{
    public GameObject prefabToSpawn;

    void Awake()
    {
        Instantiate(prefabToSpawn, this.transform.position, Quaternion.identity);
    }
}

using UnityEngine;
using UnityEngine.UI;

public class Ishihara : MonoBehaviour
{
    public Image platePrefab;
    public Sprite[] plates;

    void Start()
    {
        foreach (Sprite plate in plates)
        {
            Image image = Instantiate(platePrefab, transform);
            image.name = plate.name;
            image.sprite = plate;
        }
    }
}
